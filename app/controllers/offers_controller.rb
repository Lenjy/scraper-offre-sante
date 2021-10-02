class OffersController < ApplicationController
  before_action :find_offer, only: [:show, :edit, :create, :update, :destroy]
  def index
    @offers = Offer.all
    # ScraperParisien.new.save_offers
    # ScraperBretagne.new.save_offers
  end

  def show
  end

  def edit
  end

  def create
    @offer.update(offer_params)
    if @offer.save
      redirect_to @offer
    else
      render :edit
    end
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
    # raise
    @offer.destroy
    redirect_to offers_path
  end

  def search
    ScraperParisien.new.save_offers
    ScraperBretagne.new.save_offers
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
