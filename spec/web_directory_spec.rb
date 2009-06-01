require File.dirname(__FILE__) + '/spec_helper'

describe WebDirectory do
  include MechanizeMockHelper
  MEMBERSHIP_PAGE = File.dirname(__FILE__) + '/fixtures/membership_page.html'
  it "extracts families from a membership page" do
    @web_directory = WebDirectory.new
    
    families = @web_directory.families_on_page(mechanize_page('membership_page.html'))
    families.length.should == 5
    families.map { |f| f.surname }.should == ["Alexander", "Alexander", "Anderson", "Austad", "Austad"]
  end
end
