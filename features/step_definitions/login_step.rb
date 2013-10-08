
Given /^there are users with the following attributes:$/ do |table|
  table.hashes.each do |attributes|
    country_id = Spree::Country.find_by_iso(attributes[:country]).id
    state_id = Spree::State.find_by_name(attributes[:state]).id
    address = FactoryGirl.create(:address,firstname: attributes[:firstname],
      lastname: attributes[:lastname], address1: attributes[:address1], city: attributes[:city],
      country_id: country_id,
      state_id: state_id,
      zipcode: attributes[:zip],
      phone: attributes[:phone])
    ref_source = Spree::ReferralSource.find_by_name(attributes[:referral_source])
    FactoryGirl.create(:user, email: attributes[:email], password: "123123",
      password_confirmation: "123123",
      referral_source_id: ref_source.id,
      bill_address_id: address.id
      )
  end
end
