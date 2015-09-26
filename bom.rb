require 'open-uri'
require 'nokogiri'

POSSIBLE_PAGES = 13
MAIN_TABLE_PATH = "#body > div > table table table:nth-child(2)"

class Bom
  def self.random_film_title
    index = random_index_page
    #raw_title.scan(/^[^\(]+/).first.first
  end

  def self.random_index_page
    rows = []
    while (!rows || rows.length == 0) do
      base_uri = 'http://www.boxofficemojo.com/movies/alphabetical.htm'
      doc = Nokogiri::HTML(open(base_uri + "?letter=#{ random_letter }&p=#{ random_page }.htm"))
      raise doc.css(MAIN_TABLE_PATH).text
      rows = doc.css(MAIN_TABLE_PATH + '> tr')
    end

    raise rows.map { |r| r.text }.inspect
  end

  def self.random_letter
    ('A'..'Z').to_a.sample
    'A'
  end

  def self.random_page
    (1..POSSIBLE_PAGES).to_a.sample.to_s
    '1'
  end
end