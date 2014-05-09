class BidPriceMinValidator < ActiveModel::EachValidator

  def validate_each(object, attribute, value)
    unless value.to_i > object.listing_reserve_price.to_i
      object.errors[attribute] << (options[:message] || "must be higher than the reserve_price")
    end
  end

end