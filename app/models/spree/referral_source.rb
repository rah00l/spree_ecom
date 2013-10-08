class Spree::ReferralSource < ActiveRecord::Base
  has_many :users
end
