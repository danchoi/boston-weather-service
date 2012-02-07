require 'sinatra'
require 'nokogiri'

class BostonWeatherScraper
  def scrape
    url = 'http://boston.com/?refresh=true'
    doc = Nokogiri::HTML(`curl -s #{url}`)
    n = doc.at('#homepageWeather')
    html = n.to_html
    # puts html
    html
  end
end

CACHE_FILE = File.join(File.dirname(__FILE__), 'cached.html')
CACHE_EXPIRES = 60 * 30
class BostonWeatherService < Sinatra::Base
  get('/') {
    if !File.size?(CACHE_FILE) || (Time.now - File.mtime(CACHE_FILE) > CACHE_EXPIRES)
      puts "CACHE MISS"
      html = BostonWeatherScraper.new.scrape
      File.open(CACHE_FILE, 'w') {|f| f.puts html}
    else
      puts "cache hit"
    end
    @html = File.read(CACHE_FILE)
    erb :index
  }
end

if __FILE__ == $0
  puts BostonWeatherScraper.new.scrape
  exit
end
