When(/^I click the help page link$/) do
  click_link 'help_link'
end

Then(/^I should see a the help page$/) do
  expect(page).to have_content("help@eatathome.com")
end

Given(/^I stub out Geocoder$/) do
  Geocoder.configure(:lookup => :test)

  Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => 41.66706,
      'longitude'    => -91.5722641,
      'address'      => 'Iowa City, IA, USA',
      'state'        => 'Iowa',
      'state_code'   => 'IA',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)
end