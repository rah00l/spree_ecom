module Spree
class OutOfStockNotifier < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
end
end
