class ListingsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_listing, only: [:edit, :update, :destroy]

  def index
    @listings = current_user.listings.all
  end

  def show
     @listing = Listing.find(params[:id])
     @bid = Bid.new
  end

  def new
    @listing = Listing.new
  end

  def edit
  end

  def create
    @listing = current_user.listings.new(listing_params)

    respond_to do |format|
      if @listing.save
        format.html { redirect_to listings_path, notice: 'Listing was successfully created.' }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def publish
    @listing = current_user.listings.find params[:id]
    if @listing.publish
      redirect_to listings_path, notice: "Listing Published"
    else
      redirect_to listings_path, alert: "Listing Published Failed: #{@listing.errors.full_messages}"
    end
  end

  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_listing
      @listing = current_user.listings.find params[:id]
    end

    def listing_params
      params.require(:listing).permit(:title, :detail, :end_on, :reserve_price)
    end
end
