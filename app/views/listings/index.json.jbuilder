json.array!(@listings) do |listing|
  json.extract! listing, :id, :title, :detail, :end_on, :reserve_price
  json.url listing_url(listing, format: :json)
end
