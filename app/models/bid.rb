class Bid < ActiveRecord::Base
  belongs_to :user
  belongs_to :listing

  validates :prices,        presence: {message: "must have prices"}, bid_price_min: true

  delegate :full_name,      to: :user,      prefix: true
  delegate :title,          to: :listing,   prefix: true
  delegate :detail,         to: :listing,  prefix: true
  delegate :reserve_price,  to: :listing,  prefix: true
  delegate :end_on,         to: :listing,  prefix: true

  after_create :change_reserve_price

  default_scope{order("created_at DESC")}

  
  attr_accessor :card_number, 
                :cvc,
                :card_month,
                :card_year,
                :stripe_card_token

  def change_reserve_price
    listing = self.listing
    listing.reserve_price = prices.to_i + 1
    listing.save
  end
end
