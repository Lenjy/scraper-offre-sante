class ScraperBretagne < Scraper
  
  def initialize
    @url = 'https://bretagne-marchespublics.e-marchespublics.com/recherche_d_appels_d_offres_marches_publics_1_aapc___service_____1-sante.html?iframe=1'
    @tag_offers = '.orga'
    @tag_max_pages = '#paginationControl a'
    @tag_body = '.resultatOrganismeMilieu'
    @tag_orga = '.resultatOrganismeHaut span'
    @tag_link = '.resultatOrganismeBasTab2 a'
    @tag_date = ''
    @tag_content = '.txtmark'
    @tag_number = ''
    @tag_email = ''
  end
  
  private

  def get_max_pages
    pagination = Nokogiri::HTML(open(@url)).css(@tag_max_pages)
    pagination[pagination.count - 2].text.to_i
  end

  def element_save(element)
    super.link = "https://bretagne-marchespublics.e-marchespublics.com/" + element.search(@tag_link).first.attribute("href").value
  end

  def set_next_url(i)
    @url["#{i}-"] = "#{i+1}-"
  end
end