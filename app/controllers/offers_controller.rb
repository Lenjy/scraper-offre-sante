class OffersController < ApplicationController
  before_action :find_offer, only: [:show, :edit, :update, :destroy]
  def index
    @offers = Offer.all
    scraper = Scraper.new('https://avisdemarches.leparisien.fr/appel-offre?notice_type=AAPC&kw=sant%C3%A9&where=all&page=1', '.noticard').scrape_offers
  end

  def show
  end

  def edit
  end

  def update
    @offer.update(offer_params)
    if @offer.save
      redirect_to @offer
    else
      render :edit
    end
  end

  def destroy
    @offer.delete
    redirect_to offers_path
  end

  private

  def offer_params
    params.require(:offer).permit(:title, :location)
  end

  def find_offer
    @offer = Offer.find(params[:id])
  end
end
