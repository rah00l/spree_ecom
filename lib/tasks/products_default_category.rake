# Add category as New Products for
# products those who were already created.

namespace :defualt_setting do

task :defaualt_categories => :environment do
  Spree::Category.find_or_create_by_name_and_activate_and_no_of_rows_to_show(:name=>"New Products",:activate=>1,:no_of_rows_to_show=>5)
  Spree::Category.find_or_create_by_name_and_activate_and_no_of_rows_to_show(:name=>"Upcoming Products",:activate=>1,:no_of_rows_to_show=>5)
end

task :products_default_category => :environment do
  set_cat = Spree::Category.find_by_name("New Products")
   Spree::Product.all.each do |pro|
     Spree::ProductCategory.find_or_create_by_product_id_and_category_id(:product_id => pro.id, :category_id => set_cat.id)
   end
  end

 task :add_dealer_role_into_roles => :environment do
   Spree::Role.find_or_create_by_name('dealer')
 end

 task :add_product_to_product_user_group => :environment do
   Spree::UserGroup.all.each do  |user_group|
     Spree::Product.all.each do |product|
       Spree::ProductUserGroup.find_or_create_by_product_id_and_user_group_id(product.id,user_group.id)
     end
   end
 end

  task :add_manufacture_to_manufacture_user_group => :environment do
   Spree::UserGroup.all.each do  |user_group|
     Spree::Manufacture.all.each do |manufacture|
       Spree::ManuUserGroup.find_or_create_by_manufacture_id_and_user_group_id(manufacture.id,user_group.id)
     end
   end
 end

end