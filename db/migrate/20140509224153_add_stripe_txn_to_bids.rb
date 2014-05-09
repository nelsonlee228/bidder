class AddStripeTxnToBids < ActiveRecord::Migration
  def change
    add_column :bids, :stripe_txn_id, :string
  end
end
