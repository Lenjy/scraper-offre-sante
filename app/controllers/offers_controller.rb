class OffersController < ApplicationController
  before_action :find_offer, only: [:show, :edit, :create, :update, :destroy]
  def index
    @offers = Offer.all
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
    params.require(:offer).permit(:orga, :title, :email, :phone_number, :content)
  end

  def find_offer
    @offer = Offer.find(params[:id])
  end
end
