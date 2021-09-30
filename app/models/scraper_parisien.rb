class ScraperParisien < Scraper
  def initialize
    @url = 'https://avisdemarches.leparisien.fr/appel-offre?notice_type=AAPC&kw=sant%C3%A9&where=all&page=1'
    @tag_offers = '.noticard'
    @tag_max_pages = '.paginate'
    @tag_body = '.noticard-body'
    @tag_orga = '.noticard-orga'
    @tag_link = '.noticard-footer-right a'
    @tag_date = ''
    @tag_content = '.txtmark'
    @tag_number = ''
    @tag_email = ''
    @tag_code = ''
  end

  private

  def element_save(element)
    super.link = element.search(@tag_link).first.attribute("href").value
  end

  def get_max_pages
    super.match(/\S (\d)/).to_a.last.to_i
  end

  # def details_element(offer_saved)
  #   html_details = open(offer_saved.link)
  #   doc_details = Nokogiri::HTML(html_details)
  #   if doc_details.css(".txtmark") == []
  #     # details_link(doc_details, offer, ".login-content")
  #     offer_saved.content = doc_details.css(".login-content").text.strip
  #   else
  #     # details_link(doc_details, offer, ".txtmark p")
  #     offer_saved.content = doc_details.css(".txtmark p").text.strip
  #   end
  #   offer.number = offer.content.match(VALID_PHONE_NUMBER).to_a.first
  #   offer.email = offer.content.match(VALID_EMAIL_REGEX).to_a.first
  #   offer.code = offer.content.match(VALID_CODE_NUTS).to_a.first
  #   offer.save
  # end
end