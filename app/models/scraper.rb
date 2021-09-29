require 'nokogiri'
require 'open-uri'

VALID_EMAIL_REGEX = /(([A-Za-z0-9]*\.+*_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\+)|([A-Za-z0-9]+\+))*[A-Z‌​a-z0-9]+@{1}((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,4}/
VALID_PHONE_NUMBER = /(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}/
VALID_CODE_NUTS = /NUTS\s?:\s?FR\d{3}/

class Scraper
  attr_writer :url

  def initialize(url, tag)
    @url = url
    @tag = tag
  end

  def scrape_offers(tag)
    doc = open_page(@url)
    result = []
    pages = doc.css(".paginate").last.text.match(/\S (\d)/).to_a.last.to_i
    pages.times do
      doc.css(@tag).each do |content|
        if content.css(".noticard-body").text.strip.downcase.match?(/assurances?/)
          title = content.css(".noticard-body").text.strip
          orga = content.css(".noticard-orga").text.strip
          if Offer.find_by(title: title, orga: orga).nil?
            offer = Offer.create( title: title,
                        orga: orga,
                        dept: content.css(".noticard-dept").text.match(/(\d+)/).to_s,
                        link: content.search(".noticard-footer-right a").first.attribute("href").value
            )
            html_details = open(offer.link)
            doc_details = Nokogiri::HTML(html_details)
            if doc_details.css(".txtmark") == []
              details_link(doc_details, offer, ".login-content")
            else
              details_link(doc_details, offer, ".txtmark p")
            end
          end
        end
      end
      doc = open_page(@url.chop + (@url.chars.last.to_i + 1).to_s)
    end
    result
  end

  private

  def get_offers_array(url,tag)
    url = url
    html = open(url)
    return Nokogiri::HTML(html).css(tag)
  end

  def details_link(doc_details, offer, tag)
    offer.content = doc_details.css(tag).text.strip
    offer.number = offer.content.match(VALID_PHONE_NUMBER).to_a.first
    offer.email = offer.content.match(VALID_EMAIL_REGEX).to_a.first
    offer.code = offer.content.match(VALID_CODE_NUTS).to_a.first
    offer.save
  end
end
