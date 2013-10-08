Given /^I have logged in as an admin$/ do
  visit ('/login')
  fill_in "user_email", :with => "admin@user.com"
  fill_in "user_password", :with => "12312"
  click_button "Sign in"
end