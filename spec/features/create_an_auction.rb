require 'spec_helper'

feature "Creating a Listing" do

  let(:user) {create(:user, email: "valid@email.com", password: "somepassword")}

  before do
    user
    visit login_path
    email = page.find_by_id("_email")
    password = page.find_by_id("_password")
    email.set("valid@email.com")
    password.set("somepassword")
    click_button "Sign In"
  end

  it "creates an listing in the database" do
    visit root_path
    click_on "New Listing"
    title = page.find_by_id("listing_title")
    detail = page.find_by_id("listing_detail")
    reserve_price = page.find_by_id("listing_reserve_price")
    title.set("some valid title")
    detail.set("some valid detail")
    reserve_price.set("100")
    save_and_open_page
    click_on "Create Listing"
    expect(current_path).to eq(listings_path)
    expect(page).to have_text /some valid title/i
  end

  it "doesn't create an title with empty title" do
    visit new_listing_path
    save_and_open_page
    fill_in "listing_title", with: ""
    fill_in "listing_detail", with: "some valid detail"
    click_on "Create Listing"
    expect(page).to have_text(/must have title/i)
    expect(Listing.count).to eq(0)
  end

end