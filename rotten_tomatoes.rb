require 'open-uri'
require 'nokogiri'

class RottenTomatoes
  def self.random_film_title
    base_uri = 'http://d3biamo577v4eu.cloudfront.net/api/private/v1.0/m/list/find?page=1&limit=120&type=in-theaters&sortBy=popularity'
    titles = JSON.parse(open(base_uri).read)['results'].map { |f| f['title'] }
    titles.sample
  end
end
