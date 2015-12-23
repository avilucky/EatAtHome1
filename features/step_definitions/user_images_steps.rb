Given(/^I am on add a personal image page$/) do
  visit new_user_user_image_path(User.find(1))
end

When(/^I add the user image file at "(.*?)"$/) do |img|
  attach_file('user_images_img', File.absolute_path(img))
end

When(/^I click on the add user image button$/) do
  click_button "Save"
end

Given(/^the following user images have been added to the database$/) do |table|
 table.hashes.each do |user_image|
    fi = UserImage.new(user_image)
    fi.save!
  end
end

Given(/^I am on my profile page$/) do
    visit user_path(User.find(1))
end