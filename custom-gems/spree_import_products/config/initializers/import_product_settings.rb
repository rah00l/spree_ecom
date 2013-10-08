# This file is the thing you have to config to match your application

IMPORT_PRODUCT_SETTINGS = {
#  :column_mappings => { #Change these for manual mapping of product fields to the CSV file
#    :sku => 0,
#    :name => 1,
#    :master_price => 2,
#    :cost_price => 3,
#    :weight => 4,
#    :height => 5,
#    :width => 6,
#    :depth => 7,
#    :image_main => 8,
#    :image_2 => 9,
#    :image_3 => 10,
#    :image_4 => 11,
#    :description => 12,
#    :category => 13
#  },

  :column_mappings => { #Change these for manual mapping of product fields to the CSV file
    :sku => 0,
    :name => 1,
    :description => 2,
    :permalink => 3,
    :image_main => 4,
    :price => 5,
    :cost_price => 6,
    :image_med => 7,
    :image_lrg => 8,
    :image_sm_1 => 9,
    :image_xl_1 => 10,
    :image_sm_2 => 11,
    :image_xl_2 => 12,
    :image_sm_3 => 13,
    :image_xl_3 => 14,
    :image_sm_4 => 15,
    :image_xl_4 => 16,
    :image_sm_5 => 17,
    :image_xl_5 => 18,
    :image_sm_6 => 19,
    :image_xl_6 => 20,
    :min_quantity	 => 21,
    :max_quantity	 => 22,
    :count_on_hand => 23,
    :weight	 => 24,
    :available_on => 25,
    :created_at	=> 26,
    :manufacture_id	 => 27,
    :categories_name_1 => 28,
    :categories_image_1	 => 29,
    :categories_name_2  => 30,
    :categories_image_2 => 31,
    :categories_image_3	 => 32,
    :categories_name_3  => 33,
    :categories_name_4  => 34,
    :categories_image_4	 => 35,
    :categories_image_5	 => 36,
    :categories_name_5  => 37,
    :tax_class_title  => 38,
    :status  => 39,
    :EOREOR  => 40,
  },
  :create_missing_taxonomies => true,
  :taxonomy_fields => [:category, :brand], #Fields that should automatically be parsed for taxons to associate
  :image_fields => [:image_main, :image_med, :image_lrg, :image_sm_1], #Image fields that should be parsed for image locations
  :product_image_path => "#{Rails.root}/lib/etc/product_data/product-images/", #The location of images on disk
  :rows_to_skip => 1, #If your CSV file will have headers, this field changes how many rows the reader will skip
  :log_to => File.join(Rails.root, '/log/', "import_products_#{Rails.env}.log"), #Where to log to
  :destroy_original_products => false, #Delete the products originally in the database after the import?
  :first_row_is_headings => true, #Reads column names from first row if set to true.
  :create_variants => true, #Compares products and creates a variant if that product already exists.
  :variant_comparator_field => :permalink, #Which product field to detect duplicates on
  :multi_domain_importing => true, #If Spree's multi_domain extension is installed, associates products with store
  :store_field => :store_code #Which field of the column mappings contains either the store id or store code?
}

