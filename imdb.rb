require 'open-uri'
require 'nokogiri'

IMDB_GENRES = 'action','adventure','animation','biography','comedy','crime','documentary','drama','family','fantasy','film_noir','history','horror','music','musical','mystery','romance','sci_fi','short','sport','thriller','war','western'

class Imdb
  def self.random_film_title
    case [:genre, :genre, :genre, :top, :top, :recent].sample
    when :top
      doc = Nokogiri::HTML(open(top_charts_page))
      return doc.css('table.chart tbody td.titleColumn > a').to_a.map(&:text).sample
    when :genre
      doc = Nokogiri::HTML(open(random_genre_page))
      return doc.css('table.results:first tr.detailed td.title > a').to_a.map(&:text).sample
    when :recent
      doc = Nokogiri::HTML(open(recent_charts_page))
      return doc.css('#boxoffice table.chart tbody td.titleColumn > a').to_a.map(&:text).sample
    end
  end

  def self.random_genre_page
    "http://www.imdb.com/search/title?genres=#{ IMDB_GENRES.sample }&title_type=feature&sort=moviemeter,asc"
  end

  def self.top_charts_page
    "http://www.imdb.com/chart/top"
  end

  def self.recent_charts_page
    "http://www.imdb.com/chart/"
  end
end
