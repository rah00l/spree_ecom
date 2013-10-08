
Given /^there are countries with the following attributes:$/ do |table|
  table.hashes.each do |attributes|
    FactoryGirl.create(:country,
      iso_name: attributes[:iso_name], iso: attributes[:iso], iso3: attributes[:iso3],
      name: attributes[:name], numcode: attributes[:numcode])
  end
end

Given /^there are states with the following attributes:$/ do |table|
  table.hashes.each do |attributes|
    country = Spree::Country.find_by_iso(attributes[:country])
    FactoryGirl.create(:state,
      name: attributes[:name], abbr: attributes[:abbr], 
      country_id: country.id)
  end
end

Given /^there are referral sources with the following attributes:$/ do |table|
  table.hashes.each do |attributes|
    FactoryGirl.create(:referral_source, name: attributes[:name])
  end
end

Given /^I am on home page$/ do
  visit spree_path
end

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content text
end

When /^I follow "([^"]*)"$/ do |link|
  visit ('/login')
end

When /^I follow "([^"]*)" for signup$/ do |link|
  visit ('/signup')
end

When /^I fill in "([^"]*)" with "([^"]*)"$/ do |arg1, arg2|
  fill_in arg1, :with => arg2
end

When /^I select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end

When /^I press "([^"]*)"$/ do |button|
  click_button button
end

When /^I wait for (\d+) seconds$/ do |secs|
  sleep secs.to_i
end

