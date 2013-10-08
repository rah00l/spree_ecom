module Spree
class PromotionHistory < ActiveRecord::Base
  belongs_to :user 
  belongs_to :promotion, :foreign_key => 'activator_id' 
  end
end