When /^I go to the sign in page$/ do
  visit ('/login')
end

When /^I sign in admin login$/ do
  within("#existing-customer") do
    fill_in 'Email', :with => 'spree@example.com'
    fill_in 'Password', :with => 'spree123'
  end
#  puts html
  click_button 'Login'
end


Then /^I See link "([^"]*)"$/ do |arg1|
#  puts html
  assert page.has_content?(arg1)
end


When /^I go to the admin$/ do
  visit ('/admin')
end

Then /^I see to "([^"]*)"$/ do |arg1|
  assert page.has_content?(arg1)
end

When /^I go to the configurations$/ do
 visit ('admin/configurations')
end

When /^I go to the Front Page Highlights$/ do
  visit admin_categories_path
end


Then /^I See "([^"]*)"$/ do |arg1|
  assert page.has_content?(arg1)
end

Given /^a user visits the Front Page Highlights list page$/ do
     visit admin_categories_path
end

#When /^I follow "([^"]*)"$/ do |arg1|
#  visit new_admin_category_path
#end

When /^I fill in "([^"]*)"$/ do |arg1|
  fill_in 'Name', :with => 'Spotlight Products'
end

#When /^I press "(.*?)"$/ do |arg1|
#  click_button(arg1)
#end

#Then /^I should see "(.*?)"$/ do |arg1|
#  assert page.has_content?(arg1)
#end
