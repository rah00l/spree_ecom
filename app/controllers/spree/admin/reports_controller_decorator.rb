Spree::Admin::ReportsController.class_eval do
require 'csv'
include ActionView::Helpers::NumberHelper
include Spree::Admin::ProductsHelper

  def products_below_mimimum_quantity
    @products = Spree::Product.below_minimum_quantity
  end

  def low_stock_report
    params[:reorder_level] = "" if params[:reorder_level].blank?
    params[:inactive_products] = params[:inactive_products].present? ? "Active" : ""
    params[:min_zero_products] = params[:min_zero_products].present? ? 0 : ""
    no_of_days = params[:no_of_days_for_sales]
    no_of_days.gsub!(' Days','') if params[:no_of_days_for_sales]
    @products = Spree::Product.where("count_on_hand < ? OR status=? OR min_quantity=?",
    params[:reorder_level],params[:inactive_products],params[:min_zero_products]).order(:name).not_deleted
    if params[:format].eql?("xls")
      build_low_stock_report(@products,params[:no_of_days_for_sales])
    end
      
    respond_to do|format|
      format.html
      format.xls { send_file("#{Rails.root}/LowStock.xls") }
    end
  end

  def build_low_stock_report(products,no_of_days)
    header = ['No.','Product Name','Qty. Available','Model',"#{no_of_days} Days Sales",'Remaning Supply Days']
    CSV.open("#{Rails.root}/LowStock.xls", "w") do |csv|
      csv << header
      count = 1
      products.each do |p|
        qty = no_of_days_product_sold(p,no_of_days)
        rmt_sup = remaining_stock_supply(qty,no_of_days,p.count_on_hand)
        csv << [count,
          p.name.titleize,
          p.count_on_hand,
          p.sku,
          qty,
          rmt_sup]
        count = count + 1
      end
    end
  end

  def referral_source_report
    @referral_sources = Spree::ReferralSource.order(:name)
    if params[:format].eql?("xls")
      build_referral_sources_report(@referral_sources)
    end
    respond_to do|format|
      format.html
      format.xls { send_file("#{Rails.root}/ReferralSources.xls") }
    end
  end


def build_referral_sources_report(referral_sources)
  header = ['Sources','Referred']
    CSV.open("#{Rails.root}/ReferralSources.xls", "w") do |csv|
      csv << header
      referral_sources.each do |ref_source|
      csv << [ref_source.name,
        ref_source.users.count
      ]
      end
    end
end

def customer_report
  if params[:customer].present? 
    @orders = Spree::Order.where("state =? and completed_at > ? and completed_at < ?",'complete',params[:customer][:start_date],params[:customer][:end_date]).order("total desc") if params[:customer][:start_date].present? && params[:customer][:end_date].present?
  end
  if params[:format].eql?("xls")
      build_customer_report(@orders)
    end
    respond_to do|format|
      format.html
      format.xls { send_file("#{Rails.root}/Customers.xls") }
    end
end

def build_customer_report(orders)
    header = ["No.","#{t(:customers)}","#{t(:user_group)}","#{t(:percent)} #{t(:margine)} #{t(:per)} #{t(:order)}"," #{t(:total)} #{t(:purchased)}"]
    CSV.open("#{Rails.root}/Customers.xls", "w") do |csv|
      csv << header
      count = 1
      tot_per_margine = 0
      orders.each do |order|
          customer = order.user
          customer_user_group = "#{customer.user_group.name rescue ''}"
          customer_name = "#{customer.bill_address.firstname rescue ''} #{customer.bill_address.lastname rescue ''}"
          per_margine = percent_margin(order)
      csv << [count,
        customer_name,
          customer_user_group,
        per_margine,
        order.total.to_s
      ]
      count = count + 1
      tot_per_margine = tot_per_margine + per_margine
      end
      tot_per_mar = (tot_per_margine.to_f/count.to_f).round
      csv << ["Total % Margine",'','',"#{tot_per_mar}"]
    end
end

def manufacture_sales_report
  if params[:manufacture_sales].present?
    @manufactures = Spree::Manufacture.all
  end
  if params[:format].eql?("xls")
      build_manufacture_sales_report(@manufactures)
    end
    respond_to do|format|
      format.html
      format.xls { send_file("#{Rails.root}/ManufactureSales.xls") }
    end
end


def build_manufacture_sales_report(manufactures)
    header = ["#{t(:manufacture)} #{t(:name)}","#{t(:product)} #{t(:sold)}","#{t(:total)} #{t(:sales)}"]
    CSV.open("#{Rails.root}/ManufactureSales.xls", "w") do |csv|
      csv << header
      count = 1
      tot_per_margine = 0
      manufactures.each do |manufacture|
          product_sold = 0
          total_sale = 0
          manufacture.products.each do |product|
           qty,total = product_sold(product,params[:manufacture_sales][:start_date],params[:manufacture_sales][:end_date])
            product_sold = product_sold + qty
           total_sale = total_sale + total
         end
      csv << [
        manufacture.name,
          product_sold,
          total_sale
      ]
      end
    end
end



def margin_report
  if params[:margin].present?
    @orders = Spree::Order.where("state =? and completed_at > ? and completed_at < ?",params[:order_state],Date.parse(params[:margin][:start_date]),Date.parse(params[:margin][:end_date]))  if params[:margin][:start_date].present? && params[:margin][:end_date].present?
  end
  if params[:format].eql?("xls")
      build_margin_report(@orders)
    end
    respond_to do|format|
      format.html
      format.xls { send_file("#{Rails.root}/MarginReport.xls") }
    end
end

def build_margin_report(orders)
    header = ["#{t(:order_id)}","#{t(:items_sold)}","#{t(:sales_amount)}","#{t(:cost)}" ,"#{t(:gross_profit)} "," #{t(:percent)} #{t(:margin)} "]
    CSV.open("#{Rails.root}/MarginReport.xls", "w") do |csv|
      csv << header
      count,tot_qty,tot_sale_price,tot_cost_price,tot_gross_profit,tot_margin = 0,0,0,0,0,0
      orders.each do |order|
        order_number = "#{order.number rescue ''}"
        qty,sale_price,cost_price = order_detail(order)
        gross_profit = (sale_price.to_f - cost_price.to_f)
        margin = (((gross_profit.to_f)/sale_price.to_f)*100).round
      csv << [order_number,
        qty,
        "#{number_to_currency sale_price.to_f}",
        "#{number_to_currency cost_price.to_f}",
        "#{number_to_currency gross_profit.to_f}",
        margin,
      ]
      tot_qty += qty
      tot_sale_price += sale_price.to_f
      tot_cost_price += cost_price.to_f
      tot_gross_profit += gross_profit.to_f
      tot_margin += margin.to_i
      count = count + 1
      end
      csv << ['']
      csv << ["#{t(:total)} #{t(:sold)} #{t(:product)}","#{tot_qty}"]
      csv << ["#{t(:total)} #{t(:sales)} #{t(:amount)}","#{number_to_currency tot_sale_price.to_f}"]
      csv << ["#{t(:total)} #{t(:sold)} #{t(:product)}","#{number_to_currency tot_cost_price.to_f}"]
      csv << ["#{t(:gross_profit)} #{t(:total)}","#{number_to_currency tot_gross_profit}"]
      csv << ["#{t(:total)} #{t(:margin)}","#{tot_margin}"]
    end
end

end
