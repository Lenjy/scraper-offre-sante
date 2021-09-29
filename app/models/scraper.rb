require 'nokogiri'
require 'open-uri'
# require "offer.rb"
# require 'pry'

class Scraper
  attr_writer :url

  def initialize(url, tag)
    @url = url
    @tag = tag
  end

  def scrape_offers
    doc = open_page(@url)
    result = []
    pages = doc.css(".paginate").last.text.match(/\S (\d)/).to_a.last.to_i

    pages.times do
      doc.css(@tag).each do |content|
        if content.css(".noticard-body").text.strip.downcase.match?(/assurances?/)
          # new_offer = Offer.new(title: content.text.strip, location: content.css(".noticard-orga").text.strip)
          # result << new_offer

          result << { title: content.css(".noticard-body").text.strip,
                      orga: content.css(".noticard-orga").text.strip,
                      dept: content.css(".noticard-dept").text.match(/(\d+)/).to_s,
                      date: content.css(".date").text.match(/\d+\S\d+\S\d+ à \d+h/).to_s
          }
        
        end
      end
      # next_page = @url.chars.last.to_i + 1
      # @url = @url.chop + next_page.to_s
      doc = open_page(@url.chop + (@url.chars.last.to_i + 1).to_s)
    end
    
    return result
  end

  private

  def open_page(url)
    @url = url
    html = open(url)
    return Nokogiri::HTML(html)
  end
end


scraper = Scraper.new('https://avisdemarches.leparisien.fr/appel-offre?notice_type=AAPC&kw=sant%C3%A9&where=all&page=1', '.noticard').scrape_offers
p scraper