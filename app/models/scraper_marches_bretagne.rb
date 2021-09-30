class ScraperMarchesBretagne < Scraper
  
  def initialize
    @url = 'https://bretagne-marchespublics.e-marchespublics.com/recherche_d_appels_d_offres_marches_publics_1_aapc___service_____1-sante.html?iframe=1'
    @tag_offer = '.orga'
  end
  
  
end