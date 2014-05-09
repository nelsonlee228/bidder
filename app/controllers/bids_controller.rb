class BidsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_listing , only: [:create, :destroy]
  before_action :not_current_user_listing?, only: [:create]

  def index
    @bids = current_user.bids
  end

  def create
    # token = params[:bid] ? params[:bid][:stripe_card_token] : ""
    # service = Bid::CreateBid.new(user: current_user,
    #                              stripe_token: token,
    #                              listing: @listing)

    # if service.call
    #   redirect_to @listing, notice: "Thank you"
    # else
    #   @bid = service.bid
    #   render :new
    # end
    @bid             = @listing.bids.new(bid_attributes)
    @bid.user        = current_user


    respond_to do |format| 
      if check_bid_price && @bid.save
        format.html {redirect_to @listing, notice: "Bid created successfully" }
        format.js { render }
      else
        format.js { render :error}
        format.html {redirect_to @listing, notice: "You must bid higher than $#{@listing.reserve_price}" } 
      end
    end
  end

  def destroy
    @bid = @listing.bids.find params[:id] 
    
    respond_to do |format|
      if @bid.user == current_user && @bid.destroy 
        format.html{redirect_to @listing, notice: "Bid deleted"}
        format.js { render }
      else
        format.html{redirect_to @listing, error: "We had trouble deleting"}
        format.js { render js: "alert('error');" }
      end
    end
  end

  private

  def bid_attributes
    params.require(:bid).permit([:prices])
  end

  def find_listing
    @listing = Listing.find(params[:listing_id])
  end

  def not_current_user_listing?
    redirect_to :back, notice: "you can't bid on your own auction item" unless @listing.user != current_user
  end

  def check_bid_price
    @bid.prices.to_i > @listing.reserve_price.to_i
  end
end
