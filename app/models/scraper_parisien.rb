class ScraperParisien < Scraper
  def initialize
    @url = 'https://avisdemarches.leparisien.fr/appel-offre?notice_type=AAPC&kw=sant%C3%A9&where=all&page=1'
    @tag = '.noticard'
  end

  def save_offers
    doc = scrape_offers(@url,@tag)
    get_pages.times do

    end
  end

  private

  def get_pages
    open_page(@url).css(".paginate").last.text.match(/\S (\d)/).to_a.last.to_i
  end
end