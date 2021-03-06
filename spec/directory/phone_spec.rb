require File.dirname(__FILE__) + '/../spec_helper'

describe Directory::Phone do
  before(:each) do
    Directory.local_area_code = nil
  end
  
  it "should render as a string" do
    Directory::Phone.parse("(111) 111-1111").to_s.should == "(111) 111-1111"
  end
  
  it "should render work phone numbers with a w: prefix" do
    Directory::Phone.parse("(111) 111-1111 work").to_s.should == "work: (111) 111-1111"
  end
  
  it "should recognize work numbers" do
    Directory::Phone.parse("(111) 111-1111 work").should be_work
  end
  
  it "should recognize arbitrary locations" do
    phone =     Directory::Phone.parse("(111) 111-1111 (alex)")
    phone.location.should == "alex"
    phone.to_s.should == "alex: (111) 111-1111"
  end
  
  it "should render with respect to an area code" do
    Directory.local_area_code = "111"
    Directory::Phone.parse("(111) 111-1111").to_s.should == "111-1111"
    Directory::Phone.parse("(222) 222-2222").to_s.should == "(222) 222-2222"
  end
end
