module Spree
  class LineItem < ActiveRecord::Base
    before_validation :adjust_quantity
    belongs_to :order
    belongs_to :variant

    has_one :product, :through => :variant
    has_many :adjustments, :as => :adjustable

    before_validation :copy_price

    validates :variant, :presence => true
    validates :quantity, :numericality => { :only_integer => true, :message => I18n.t('validation.must_be_int') }
    validates :price, :numericality => true
    validate :stock_availability
    validate :quantity_no_less_than_shipped

    attr_accessible :quantity
    cattr_accessor :current_user
#    after_initialize :custom_price

    before_save :update_inventory
    before_destroy :ensure_not_shipped, :remove_inventory

    after_save :update_order
    after_destroy :update_order
    
    def custom_price
#      raise self.inspect
      if current_user && current_user.user_group && current_user.user_group.manu_user_groups && self.product.manufacture && current_user.user_group.manu_user_groups.find_by_user_group_id_and_manufacture_id(current_user.user_group.id,self.product.manufacture.id)
        manu_user_group_price_discount = current_user.user_group.manu_user_groups.find_by_user_group_id_and_manufacture_id(current_user.user_group.id,self.product.manufacture.id).price_discount
      end

      if manu_user_group_price_discount
        discount_price = ((self.price.to_f*self.product.manufacture.percent_discount.to_f)/100).round(2)
        self.price = self.price.to_f - discount_price.to_f
      end

      if current_user && current_user.user_group && current_user.user_group.product_user_groups && current_user.user_group.product_user_groups.find_by_user_group_id_and_product_id(current_user.user_group.id,self.product.id)
        user_group_price = current_user.user_group.product_user_groups.find_by_user_group_id_and_product_id(current_user.user_group.id,self.product.id).price
      end

      if user_group_price && user_group_price > 0
        self.price = user_group_price
      end
    end

    def copy_price
      self.price = variant.price if variant && self.price.nil?
    end

    def increment_quantity
      self.quantity += 1
    end

    def decrement_quantity
      self.quantity -= 1
    end

    def amount
      custom_price

      self.price * self.quantity
    end
    alias total amount

    def adjust_quantity
      self.quantity = 0 if self.quantity.nil? || self.quantity < 0
    end

    def sufficient_stock?
      Spree::Config[:allow_backorders] ? true : (self.variant.on_hand >= self.quantity)
    end

    def insufficient_stock?
      !sufficient_stock?
    end

    private
      def update_inventory
        return true unless self.order.completed?

        if self.new_record?
          InventoryUnit.increase(self.order, self.variant, self.quantity)
        elsif old_quantity = self.changed_attributes['quantity']
          if old_quantity < self.quantity
            InventoryUnit.increase(self.order, self.variant, (self.quantity - old_quantity))
          elsif old_quantity > self.quantity
            InventoryUnit.decrease(self.order, self.variant, (old_quantity - self.quantity))
          end
        end
      end

      def remove_inventory
        return true unless self.order.completed?

        InventoryUnit.decrease(self.order, self.variant, self.quantity)
      end

      def update_order
        # update the order totals, etc.
        order.update!
      end

      def ensure_not_shipped
        if order.try(:inventory_units).to_a.any?{|unit| unit.variant_id == variant_id && unit.shipped?}
          errors.add :base, I18n.t('validation.cannot_destory_line_item_as_inventory_units_have_shipped')
          return false
        end
      end

      # Validation
      def stock_availability
        return if sufficient_stock?
        errors.add(:quantity, I18n.t('validation.cannot_be_greater_than_available_stock'))
      end

      def quantity_no_less_than_shipped
        already_shipped = order.shipments.reduce(0) { |acc,s| acc + s.inventory_units.count { |i| i.variant == variant } }
        unless quantity >= already_shipped
          errors.add(:quantity, I18n.t('validation.cannot_be_less_than_shipped_units'))
        end
      end
  end
end
