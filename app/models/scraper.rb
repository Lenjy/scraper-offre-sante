require 'nokogiri'
require 'open-uri'

VALID_EMAIL_REGEX = /(([A-Za-z0-9]*\.+*_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\+)|([A-Za-z0-9]+\+))*[A-Z‌​a-z0-9]+@{1}((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,4}/
VALID_PHONE_NUMBER = /(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}/
VALID_CODE_NUTS = /NUTS\s?:\s?FR\d{3}/

class Scraper
  attr_writer :url

  def initialize( attributes = {})
    @url = attributes[:url]
    @tag_offers = attributes[:tag_offer]
    @tag_max_pages = attributes[:tag_max_pages]
    @tag_body = attributes[:tag_body_offer]
    @tag_orga = attributes[:tag_orga]
    @tag_link = attributes[:tag_link]
    @tag_date = attributes[:tag_date]
    @tag_content = attributes[:tag_content]
    @tag_number = attributes[:tag_number]
    @tag_email = attributes[:tag_email]
    @tag_code = attributes[:tag_code]
  end

  def save_offers
    i = 1
    get_max_pages.times do
      get_all_offers.each do |element|
        if match_key_words?(element) && not_saved?(element)
          offer_saved = element_save(element)
          details_link(get_link_offer(offer_saved), offer_saved)
        end
      end
      set_next_url(i)
      i += 1
    end
  end

  private

  def get_max_pages
    Nokogiri::HTML(open(@url)).css(@tag_max_pages).last.text
  end

  def not_saved?(element)
    Offer.find_by(title: element.css(@tag_body).text.strip, orga: element.css(@tag_orga).text.strip).nil?
  end

  def match_key_words?(element)
    element.css(@tag_body).text.strip.downcase.match?(/assurances?/) || element.css(@tag_body).text.strip.downcase.match?(/complementaires?/)
  end

  def get_all_offers
    # @url = url
    html = open(@url)
    Nokogiri::HTML(html).css(@tag_offers)
  end

  def element_save(element)
    Offer.create( title: element.css(@tag_body).text.strip,
                  orga: element.css(@tag_orga).text.strip
                  # dept: element.css(@tag).text.match(/(\d+)/).to_s,
                )
  end

  def get_link_offer(offer)
    Nokogiri::HTML(open(offer.link))
  end

  def details_link(doc_details, offer)
    offer.content = doc_details.css(@tag_content).text.strip
    offer.number = offer.content.match(VALID_PHONE_NUMBER).to_a.first
    offer.email = offer.content.match(VALID_EMAIL_REGEX).to_a.first
    offer.code = offer.content.match(VALID_CODE_NUTS).to_a.first
    offer.save
  end

  def set_next_url(i)
    @url = @url.chop + (@url.chars.last.to_i + i).to_s
  end
end
