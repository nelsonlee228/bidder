class AddUserReferencesToListing < ActiveRecord::Migration
  def change
    add_reference :listings, :user, index: true
  end
end
