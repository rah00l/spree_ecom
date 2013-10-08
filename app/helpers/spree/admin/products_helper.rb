module Spree
  module Admin
    module ProductsHelper
      def option_type_select(so)
        select(:new_variant,
          so.option_type.presentation,
          so.option_type.option_values.collect { |ov| [ ov.presentation, ov.id ] })
      end

      def pv_tag_id(product_value)
        "product-property-value-#{product_value.id}"
      end

      def no_of_days_product_sold(product,no_of_days)
        qty = 0
        if product.variants.empty?
          product.master.line_items.each do |li|
            if li.order.state == "complete" && li.order.completed_at > no_of_days.to_i.days.ago && li.order.completed_at < Time.now
              qty += li.quantity.to_i
            end
          end
        else
          product.variants.each do |variant|
            variant.line_items.each do |li|
              if li.order.state == "complete" && li.order.completed_at > no_of_days.to_i.days.ago && li.order.completed_at < Time.now
                qty += li.quantity.to_i
              end
            end
          end
        end
        return qty
      end

      def remaining_stock_supply(qty,no_of_days,product_count_on_hand)
        ((qty.to_f/no_of_days.to_f) * product_count_on_hand).round
      end

      def percent_margin(order)
        order.line_items.each do |li|
          return (((li.variant.price.to_f - li.variant.cost_price.to_f)/li.variant.price.to_f)*100).round
        end
      end


      def product_sold(product,start_date,end_date)
        qty,total,sale_price,cost_price = 0,0,0,0
        if product.variants.empty?
          unless product.master.blank?
          product.master.line_items.each do |li|
            if li.order.state == "complete" && li.order.completed_at > Date.parse(start_date) && li.order.completed_at < Date.parse(end_date)
              sale_price += li.variant.price.to_f  
              cost_price += li.variant.cost_price.to_f
              qty += li.quantity.to_i
              total += li.order.total.to_f
            end
          end
          end
        else
          unless product.variants.blank?
          product.variants.each do |variant|
            unless variant.blank?
            variant.line_items.each do |li|
              if li.order.state == "complete" && li.order.completed_at > Date.parse(start_date) && li.order.completed_at < Date.parse(end_date)
                sale_price += li.variant.price.to_f
                cost_price += li.variant.cost_price.to_f
                qty += li.quantity.to_i
                total += li.order.total.to_f
              end
            end
            end
            end
          end
        end
        return qty,total,sale_price,cost_price
      end

      def cal_percent_margin(product)
        if product.variants.empty?
          unless product.master.blank?
            if li.order.state == "complete" && li.order.completed_at > Date.parse(start_date) && li.order.completed_at < Date.parse(end_date)

            end
          end
          else
          unless product.variants.blank?

          end
        end
      end

      def order_detail(order)
        qty = 0
        sale_price = 0
        cost_price = 0
        order.line_items.each do |li|
          qty += li.quantity.to_i
          if li.variant
            sale_price += (li.variant.price.to_f * li.quantity.to_i)
            cost_price += (li.variant.cost_price.to_f * li.quantity.to_i)
          end
        end
        return qty,sale_price,cost_price
      end
    end
  end
end
