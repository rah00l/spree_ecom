module Spree
class PopulateMultiplePromoCode < ActiveRecord::Base
  belongs_to :promotion, :foreign_key => 'activator_id'
  belongs_to :user
end
end