require 'spec_helper'

describe ListingsController do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:listing) { create(:listing, user: user) }
  let(:listing1) { create(:listing, user: user1) }

  describe "#index" do
    before {login(user)}

    it "assigns a variable @listings" do
      get :index
      expect(assigns(:listings)).to be
    end

    it "includes all listings in the database" do
      listing = create(:listing, user: user)
      get :index
      expect(assigns(:listings)).to include(listing)
    end

    it "renders index template" do 
      get :index
      expect(response).to render_template(:index)
    end

  end

  describe "#new" do

    context "with signed in user" do
      before{ login(user) }
      it "assgins a new listing" do
        get :new
        expect(assigns(:listing)).to be_a_new(Listing)
      end 

      it "redners :new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context "without signin user" do
      it "redirect to sign in page" do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end 
  end

  describe "#create" do
    context "with sign in user" do
      before {login(user)}

      context "with valid relisting" do

        def valid_request
          post :create, listing: {title: "valid title" , detail: "valid detail", end_on:Faker::Business.credit_card_expiry_date, reserve_price:Faker::Number.number(3)  }
        end


        it "creates a listing in the database" do
          expect do
            post :create, listing: {title: "valid title" , detail: "valid detail", end_on:Faker::Business.credit_card_expiry_date, reserve_price:Faker::Number.number(3) }
          end.to change{ Listing.count }.by(1)
        end

        it "redirects to listings listing page with valid request" do
          valid_request
          expect(response).to redirect_to(listings_path)
        end

        it "sets a flash message" do
          valid_request
          expect(flash[:notice]).to be
        end

        it "assigns the listings to the signed in user" do
          expect{ valid_request }.to change { user.listings.count }.by(1)
        end

      end

      context "with invalid relisting" do
        def invalid_request
          post :create, listing: { title: "", 
                                    detail: "valid_detail"}
        end

        it "doesn't change the number of listings in the database" do
          expect { invalid_request }.to_not change{ Listing.count }
        end

        it "renders new template" do
          invalid_request
          expect(response).to render_template(:new)
        end


      end

    end

    context "with no signed in user" do
      it "redirect to sign in page" do
        post :create
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "#show" do
    context "without sign in user" do
      it "assigns the listing with the passed id" do
        get :show, id: listing.id
        expect(assigns(:listing)).to eq(listing)
      end

      it "renders the show template" do
        get :show, id: listing.id
        expect(response).to render_template(:show)
      end
    end
  end

  describe "#edit" do
    context "signed out user" do
      it "redirects to new session path" do
        get :edit, id: listing.id
        expect(response).to redirect_to(login_path)
      end
    end

    context "with a sign in user" do
      before {login(user)}

      it "assigns the listing with current passed id" do
        get :edit, id: listing.id
        expect(assigns(:listing)).to eq(listing)
      end

      it "raises error if trying to edit others listing" do
        expect { get :edit, id: listing1.id }.to raise_error 
      end

    end
  end

  describe "#update" do

    context "with signed in user" do
      before { login(user) }

      it "updates the listing with new title" do
        patch :update, id: listing.id, listing: {title: "some new title"}
        listing.reload
        expect(listing.title).to match /some new title/i
      end

      it "redirects to listing show page after update" do
        patch :update, id: listing.id, listing: {title: "some new title"}
        expect(response).to redirect_to(listing)
      end

      it "renders edit template with fail update" do
        patch :update, id: listing.id, listing: { title: ""}
        expect(response).to render_template(:edit)
      end

      it "sets flash message with successful update" do
        patch :update, id: listing.id, listing: { title: "new title"}
        expect(flash[:notice]).to be
      end

      it "raises an error if trying to update another user's listing" do
        expect do
        patch :update, id: listing1.id, listing: { title: "new title"}
        end.to raise_error
      end


    end
  end

  describe "#destroy" do

    context "with signed in user" do
      before {login(user)}
      before { listing }

      it "removes the listing from the database" do
        expect do
          delete :destroy, id: listing.id 
        end.to change { Listing.count }.by(-1)
      end

      it "redirects to listings listings page with success!" do
        delete :destroy, id: listing.id
        expect(response).to redirect_to(listings_path)
      end

      it "raises error when trying to delete a listing by another owner" do
        expect do
          delete :destroy, id: listing1.id
        end.to raise_error
      end

    end
  end

end