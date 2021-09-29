class ScraperParisien < Scraper
  def initialize
    @url = 'https://avisdemarches.leparisien.fr/appel-offre?notice_type=AAPC&kw=sant%C3%A9&where=all&page=1'
    @tag_offer = '.noticard'
  end

  def save_offers
    i = 1
    get_max_pages(@url, ".paginate", /\S (\d)/).times do
      get_all_offers(@url,@tag_offer).each do |element|
        if element.css(".noticard-body").text.strip.downcase.match?(/assurances?/) && element.not_saved?(element)
          offer_saved = element_save(element)
          details_element(offer_saved)
        end
      end
      @url = @url.chop + (@url.chars.last.to_i + i).to_s
    end
  end

  private

  # def get_pages(url, tag)
  #   open_page(url).css(".paginate").last.text.match(/\S (\d)/).to_a.last.to_i
  # end

  def element_save(element)
    Offer.create( title: content.css(".noticard-body").text.strip,
                        orga: content.css(".noticard-orga").text.strip,
                        dept: element.css(".noticard-dept").text.match(/(\d+)/).to_s,
                        link: element.search(".noticard-footer-right a").first.attribute("href").value
            )
  end

  def details_element(offer_saved)
    html_details = open(offer_saved.link)
    doc_details = Nokogiri::HTML(html_details)
    if doc_details.css(".txtmark") == []
      # details_link(doc_details, offer, ".login-content")
      offer_saved.content = doc_details.css(".login-content").text.strip
    else
      # details_link(doc_details, offer, ".txtmark p")
      offer_saved.content = doc_details.css(".txtmark p").text.strip
    end
    offer.number = offer.content.match(VALID_PHONE_NUMBER).to_a.first
    offer.email = offer.content.match(VALID_EMAIL_REGEX).to_a.first
    offer.code = offer.content.match(VALID_CODE_NUTS).to_a.first
    offer.save
  end
end