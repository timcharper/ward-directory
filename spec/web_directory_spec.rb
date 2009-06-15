require File.dirname(__FILE__) + '/spec_helper'

describe WebDirectory do
  include MechanizeMockHelper
  MEMBERSHIP_PAGE = File.dirname(__FILE__) + '/fixtures/membership_page.html'
  it "extracts families from the site" do
    @web_directory = WebDirectory.new
    @web_directory.stub!(:membership_directory_pages).and_return([mechanize_page('membership_page.html')])
    families = @web_directory.families
    families.length.should == 5
    families.map { |f| f.surname }.should == ["Alexander", "Alexander", "Anderson", "Austad", "Austad"]
  end
  
  it "downloads all the pages by clicking on the links B-Z" do
    @web_directory = WebDirectory.new
    @page = mechanize_page('membership_page.html')
    @web_directory.stub!(:first_membership_directory_page).and_return(@page)
    ('B'..'Z').each do |letter|
      @page.should_receive(:link_with).with(:text => letter).and_return(mock('link', :click => @page))
    end
    @web_directory.membership_directory_pages.length.should == 26
  end
end
