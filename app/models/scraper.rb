require 'nokogiri'
require 'open-uri'
# require "/root/code/Lenjy/scrap-offre-sante/app/models/offer.rb"
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
          title = content.css(".noticard-body").text.strip
          orga = content.css(".noticard-orga").text.strip
          
          # binding.pry
          
          if Offer.find_by(title: title, orga: orga).nil?
            # result << { title: title,
            #             orga: orga,
            #             dept: content.css(".noticard-dept").text.match(/(\d+)/).to_s,
            #             date: content.css(".date").text.match(/\d+\S\d+\S\d+ à \d+h/).to_s
            # }
            Offer.create( title: title,
                        orga: orga,
                        dept: content.css(".noticard-dept").text.match(/(\d+)/).to_s,
                        link: content.search(".noticard-footer-right a").first.attribute("href").value
            )
          end
        end
      end
      doc = open_page(@url.chop + (@url.chars.last.to_i + 1).to_s)
    end
    result
  end

  private

  def open_page(url)
    @url = url
    html = open(url)
    return Nokogiri::HTML(html)
  end
end
