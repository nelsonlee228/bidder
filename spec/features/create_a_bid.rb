require 'spec_helper'

feature "Creating a Bid" do

  let(:user) {create(:user, email: "valid@email.com", password: "somepassword")}
  let(:user1) {create(:user, email: "valid2@email.com", password: "somepassword")}
  let(:listing) {create(:listing, reserve_price:100, user: user) }
  let(:listing1) {create(:listing, reserve_price:100, user: user1) }

  before do
    user
    visit login_path
    email = page.find_by_id("_email")
    password = page.find_by_id("_password")
    email.set("valid@email.com")
    password.set("somepassword")
    click_button "Sign In"
  end

  it "cannot create bid in auction own by the same user" do
    listing
    visit root_path
    click_on "Show"
    price = page.find_by_id("bid_prices")
    price.set("101")
    click_on "submit"
    expect(current_path).to eq(listing_path(listing.id))
    save_and_open_page
    expect(page).to have_text "you can't bid on your own auction item"
  end

  it "creates a new bid with auction not own by the user" do
    listing1
    visit root_path
    click_on "Show"
    price = page.find_by_id("bid_prices")
    price.set("101")
    click_on "submit"
    save_and_open_page
    expect(page).to have_text(/101/i)
  end

end