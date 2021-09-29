class ScraperEurolegales < Scraper
  
  def initialize
    @url = 'https://avisdemarches.leparisien.fr/appel-offre?notice_type=AAPC&kw=sant%C3%A9&where=all&page=1'
    @tag_offer = '.noticard'
  end
  
  
end