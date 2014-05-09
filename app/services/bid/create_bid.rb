class Bid::CreateBid

  include Virtus.model

  attribute :stripe_token, String
  attribute :user, User
  attribute :listing, Listing

  attribute :bid, Bid

  def call
    build_bid
    begin
      create_customer unless user.stripe_customer_id
      @bid.stripe_txn_id = charge_customer.id
    rescue Stripe::CardError => e
      @bid.errors.add(:base, "Card Problem")
      return false
    end
    @bid.save
  end

  private

  def build_bid
    @bid               = Bid.new
    @bid.user          = user
    @bid.listing       = listing
  end

  def create_customer
    service = Stripe::CreateCustomer.new( user: user,
                                          stripe_token: stripe_token)
    service.call
  end

  def charge_customer
    charge = Stripe::ChargeCustomer.new( user: user,
                                         listing: listing)

    charge.call
  end


end