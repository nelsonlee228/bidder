class User < ActiveRecord::Base

  has_secure_password 
  has_many :listings
  has_many :bids

  # validates :email, presence: true, uniqueness: true, email_format: true

  def full_name
    if first_name || last_name
      "#{first_name} #{last_name}".squeeze(" ").strip
    else
      email
    end
  end

end
