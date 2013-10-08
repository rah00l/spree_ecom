class AddExtraFielsToSpreeProducts < ActiveRecord::Migration
  def up
    add_column :spree_products ,:image_main ,:string
    add_column :spree_products ,:image_med ,:string
    add_column :spree_products ,:image_lrg ,:string
    add_column :spree_products ,:image_sm_1 ,:string
    add_column :spree_products ,:image_xl_1 ,:string
    add_column :spree_products ,:image_sm_2 ,:string
    add_column :spree_products ,:image_xl_2 ,:string
    add_column :spree_products ,:image_sm_3 ,:string
    add_column :spree_products ,:image_xl_3 ,:string
    add_column :spree_products ,:image_sm_4 ,:string
    add_column :spree_products ,:image_xl_4 ,:string
    add_column :spree_products ,:image_sm_5 ,:string
    add_column :spree_products ,:image_xl_5 ,:string
    add_column :spree_products ,:image_sm_6 ,:string
    add_column :spree_products ,:image_xl_6 ,:string
    add_column :spree_products ,:categories_image_1 ,:string
    add_column :spree_products ,:categories_name_1 ,:string
    add_column :spree_products ,:categories_image_2 ,:string
    add_column :spree_products ,:categories_name_2 ,:string
    add_column :spree_products ,:categories_image_3 ,:string
    add_column :spree_products ,:categories_name_3 ,:string
    add_column :spree_products ,:categories_image_4 ,:string
    add_column :spree_products ,:categories_name_4 ,:string
    add_column :spree_products ,:categories_image_5 ,:string
    add_column :spree_products ,:categories_name_5 ,:string
    add_column :spree_products ,:tax_class_title ,:string
    add_column :spree_products ,:status ,:string
    add_column :spree_products ,:eoreor ,:string
  end

  def down
    remove_column :spree_products ,:image_main
    remove_column :spree_products ,:image_med
    remove_column :spree_products ,:image_lrg
    remove_column :spree_products ,:image_sm_1
    remove_column :spree_products ,:image_xl_1
    remove_column :spree_products ,:image_sm_2
    remove_column :spree_products ,:image_xl_2
    remove_column :spree_products ,:image_sm_3
    remove_column :spree_products ,:image_xl_3
    remove_column :spree_products ,:image_sm_4
    remove_column :spree_products ,:image_xl_4
    remove_column :spree_products ,:image_sm_5
    remove_column :spree_products ,:image_xl_5
    remove_column :spree_products ,:image_sm_6
    remove_column :spree_products ,:image_xl_6
    remove_column :spree_products ,:categories_image_1
    remove_column :spree_products ,:categories_name_1
    remove_column :spree_products ,:categories_image_2
    remove_column :spree_products ,:categories_name_2
    remove_column :spree_products ,:categories_image_3
    remove_column :spree_products ,:categories_name_3
    remove_column :spree_products ,:categories_image_4
    remove_column :spree_products ,:categories_name_4
    remove_column :spree_products ,:categories_image_5
    remove_column :spree_products ,:categories_name_5
    remove_column :spree_products ,:tax_class_title
    remove_column :spree_products ,:status
    remove_column :spree_products ,:eoreor
  end
end
