##GIVEN
Given (/^I am on "([^"]*)"$/) do |path|
  visit path
end


##WHEN
When (/^I fill in "(.*?)" with "(.*?)"$/) do |element, text|
  fill_in(element, :with=> text)
end

When(/^I click "(.*?)"$/) do |element|
  click_link_or_button(element)
end

When /^I press "([^\"]*)" within "([^\"]*)"$/ do |button,scope_selector|
  within(scope_selector) do
    click_button(button)
  end
end


##THEN
#for some text
Then /^I should see "([^"]*)"$/ do |text|
  assert page.has_content?(text)
end

Then /^I should not see "([^"]*)"$/ do |text|
  assert !page.has_content?(text)
end

Then /^the "([^\"]*)" field should contain "([^\"]*)"$/ do |field, value|
  find_field(field).value.should =~ /#{value}/
end

Then /^the "([^\"]*)" field should not contain "([^\"]*)"$/ do |field, value|
  find_field(field).value.should_not =~ /#{value}/
end

Then /^I should be on (.+)$/ do |page_name|
  current_path.should == path_to(page_name)
end

Then /^page should have (.+) message "([^\"]*)"$/ do |type, text|
  page.has_css?("p.#{type}", :text => text, :visible => true)
end
#for a button
Then(/^I should see "(.*?)" in a button$/) do | text|
  page.has_button?(text)
end

Then(/^I should see "(.*?)" in a link/) do | text|
  page.has_link?(text)
end

Then (/^I click "(.*?)" in a link$/) do |text|
  click_link text
end

Then (/^I should be logged in as "(.*?")$/) do |text|
  session[:usuario]=text
end

Then /^I should see "([^"]*)" or "([^"]*)"$/ do |text1, text2|
  assert (page.has_content?(text1) or page.has_content?(text2))
end