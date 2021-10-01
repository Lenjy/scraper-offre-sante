class ScraperBretagne < Scraper
  
  def initialize
    @url = 'https://bretagne-marchespublics.e-marchespublics.com/recherche_d_appels_d_offres_marches_publics_1_aapc___service_____1-sante.html?iframe=1'
    @tag_offers = '.orga'
    @tag_max_pages = '#paginationControl a'
    @tag_body = '.resultatOrganismeMilieu'
    @tag_orga = '.resultatOrganismeHaut span'
    @tag_link = '.resultatOrganismeBasTab2 a'
    @tag_date_post = '.resultatOrganismeBasTab4 p'
    @tag_content = '.text'
    @tag_phone_number = ''
    @tag_email = ''
    # @tag_date_end = '.sec_p'
    @offer_instance = nil
  end
  
  private

  def get_max_pages
    pagination = Nokogiri::HTML(open(@url)).css(@tag_max_pages)
    pagination[pagination.count - 2].text.to_i
  end

  def element_save(element)
    super.details_link = "https://bretagne-marchespublics.e-marchespublics.com/" + element.search(@tag_link).first.attribute("href").value
    @offer_instance.save
  end

  def set_next_url(i)
    @url["#{i}-"] = "#{i+1}-"
  end
end