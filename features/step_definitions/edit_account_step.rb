When /^I follow "([^"]*)" for edit account$/ do |link|
  visit ('/account')
end

When /^I follow "([^"]*)" for edit$/ do |link|
  visit ('/account/edit')
end