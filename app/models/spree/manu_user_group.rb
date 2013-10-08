class Spree::ManuUserGroup < ActiveRecord::Base
  belongs_to :user_group
  belongs_to :manufacture
end
