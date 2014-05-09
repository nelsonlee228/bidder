require 'spec_helper'

describe BidsController do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:bid) { create(:bid, user: user, listing: listing) }
  let(:bid1) { create(:bid, user: user1, listing: listing) }
  let(:listing) { create(:listing, reserve_price: 99) }

  describe "#create" do
    context "with sign in user" do
      before {login(user)}

      context "with valid bid" do

        def valid_request
          post :create, listing_id: listing.id, bid: {prices:1000} 
        end


        it "creates a bid in the database" do
          expect do
            post :create, listing_id: listing.id, bid: {prices:1000} 
          end.to change{ listing.bids.count }.by(1)
        end

        it "redirects to listing page with valid request" do
          valid_request
          expect(response).to redirect_to(listing_path(listing.id))
        end

        it "sets a flash message" do
          valid_request
          expect(flash[:notice]).to be
        end

        it "assigns the bids to the signed in user" do
          expect{ valid_request }.to change { user.bids.count }.by(1)
        end

      end

      context "with invalid bid" do
        def invalid_request
          post :create,listing_id: listing.id, bid: { prices: nil}
        end

        it "doesn't change the number of bids in the database" do
          expect { invalid_request }.to_not change{ listing.bids.count }
        end

        it "renders new template" do
          invalid_request
          expect(response).to redirect_to(listing_path(listing.id))
        end


      end

    end

    context "with no signed in user" do
      it "redirect to sign in page" do
        post :create, listing_id: listing.id, bid: {prices:1000} 
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "#destroy" do
    context "with signed in user" do
      before { login(user) }
      before { listing }
      before { bid }

      it "removes the bid from the database" do
        expect do
          delete :destroy, listing_id: listing.id, id: bid.id
        end.to change { listing.bids.count }.by(-1)
      end

      it "redirects to bids bids page with success!" do
        delete :destroy, listing_id: listing.id, id: bid.id
        expect(response).to redirect_to(listing_path(listing.id))
      end

      # it "raises error when trying to delete a bid by another owner" do
      #   expect do
      #     delete :destroy, listing_id: listing.id, id: bid1.id
      #   end.to raise_error
      # end
    end
  end

end
