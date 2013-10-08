# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)


Spree::Category.find_or_create_by_name_and_activate_and_no_of_rows_to_show(:name=>"New Products",:activate=>1,:no_of_rows_to_show=>5)
Spree::Category.find_or_create_by_name_and_activate_and_no_of_rows_to_show(:name=>"Upcoming Products",:activate=>1,:no_of_rows_to_show=>5)


set_cat = Spree::Category.find_by_name("New Products")
Spree::Product.all.each do |pro|
     Spree::ProductCategory.find_or_create_by_product_id_and_category_id(:product_id => pro.id, :category_id => set_cat.id)
   end
