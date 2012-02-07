require 'sinatra'
require 'nokogiri'

class BostonWeatherScraper
  def scrape
    url = 'http://boston.com/?refresh=true'
    doc = Nokogiri::HTML(`curl -s #{url}`)
    n = doc.at('#homepageWeather')
    html = n.to_html
    puts html
    html
  end
end

class BostonWeatherService < Sinatra::Base
  get('/') {
    @html = BostonWeatherScraper.new.scrape
    erb :index
  }
end

if __FILE__ == $0
  puts BostonWeatherScraper.new.scrape
  exit
end
