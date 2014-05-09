class Listing < ActiveRecord::Base
  has_many :bids
  belongs_to :user

  validates :title,         presence: {message: "must have title"},         uniqueness: true
  validates :detail,        presence: {message: "must have detail"}
  validates :end_on,        presence: {message: "must have end_on"}
  validates :reserve_price, presence: {message: "must have reserve_price"}

  state_machine :state, initial: :draft do
    event :publish do
      transition draft: :published
    end

    event :complete do
      transition published: :target_met
    end

    event :expire do
      transition target_met: :succeeded, published: :failed
    end

    event :cancel do
      # transition [:draft, :published, :target_met] => :canceled
      transition any => :canceled
    end

    after_transition on: :canceled, do: :refund_all_bids
  end

  def sanitize
    self.detail.squeeze!(" ")
    self.detail.strip!
  end

end
