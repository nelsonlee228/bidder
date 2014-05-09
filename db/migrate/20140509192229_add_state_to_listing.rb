class AddStateToListing < ActiveRecord::Migration
  def change
    add_column :listings, :state, :string
    add_index :listings, :state
  end
end
