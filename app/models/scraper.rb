require 'nokogiri'
require 'open-uri'
# require 'pry'

class Scraper
  attr_writer :url

  def initialize(url, tag)
    @url = url
    @tag = tag
  end

  def scrape_offers
    html = open(@url)
    doc = Nokogiri::HTML(html)
    result = []
    pages = doc.css(".paginate").last.text.match(/\S (\d)/).to_a.last.to_i

    pages.times do
      doc.css(@tag).each do |content|
        if content.text.strip.downcase.match?(/assurances?/)
          result << content.text.strip
        end
      end
      next_page = @url.chars.last.to_i + 1
      @url = @url.chop + next_page.to_s
      html = open(@url)
      doc = Nokogiri::HTML(html)
    end
    
    return result
  end
end


scraper = Scraper.new('https://avisdemarches.leparisien.fr/appel-offre?notice_type=AAPC&kw=sant%C3%A9&where=all&page=1', '.noticard-body').scrape_offers
p scraper