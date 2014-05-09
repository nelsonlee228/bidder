require 'spec_helper' #give you access to the entire rails app or you can modify to require only specific files


describe Listing do #giving us access tot he listing describe + class_name

  it "doesn't allow creating listing without content" do # or can replace with specify
    listing = Listing.new(detail:nil)
    expect(listing).to_not be_valid
  end

  it "doesn't allow creating listing without a detail" do # or can replace with specify
    listing = Listing.new(detail:nil)
    listing.save
    listing.errors.messages.should have_key(:detail)
  end

  it "doesn't allow listing detail shorter than 3 characters" do 
    listing = Listing.new(detail: "as")
    expect(listing).to_not be_valid
  end

  describe ".sanitize" do
    it "removes repeated white spaces in the detail" do
      text = "detail  with   duplicate spaces"
      listing = Listing.new(detail: text)
      listing.sanitize
      expect(listing.detail).to eq("detail with duplicate spaces")
  end

    it "strips spaces at the edges of the detail text" do
      text = " detail with spaces spaces "
      listing = Listing.new(detail: text)
      listing.sanitize
      expect(listing.detail).to eq("detail with spaces spaces")
    end
  end

end
