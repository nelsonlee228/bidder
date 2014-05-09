class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :title
      t.text :detail
      t.datetime :end_on
      t.integer :reserve_price

      t.timestamps
    end
  end
end
