class Spree::ProductUserGroup < ActiveRecord::Base
  belongs_to :user_group
  belongs_to :product
#  validates_uniqueness_of :product_id, :scope => :user_group_id
#  validates_numericality_of :price
end
