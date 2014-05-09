class Stripe::ChargeCustomer

  include Virtus.model

  attribute :user, User
  attribute :bid, bid

  def call
    charge = Stripe::Charge.create( 
            :amount       => bid.prices * 100, # amount in cents, again
            :currency     => "cad",
            :customer     => user.stripe_customer_id,
            :description  => "bid for #{bid.listing_title}"
            )
  end

  private
end