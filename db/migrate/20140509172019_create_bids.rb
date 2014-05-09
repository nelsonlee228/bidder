class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.string :prices
      t.references :user, index: true
      t.references :listing, index: true

      t.timestamps
    end
  end
end
