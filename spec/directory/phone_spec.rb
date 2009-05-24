require File.dirname(__FILE__) + '/../spec_helper'

describe Directory::Phone do
  it "should render as a string" do
    Directory::Phone.parse("(111) 111-1111").to_s.should == "(111) 111-1111"
  end
  
  it "should render work phone numbers with a w: prefix" do
    Directory::Phone.parse("(111) 111-1111 work").to_s.should == "w: (111) 111-1111"
  end
  
  it "should recognize work numbers" do
    Directory::Phone.parse("(111) 111-1111 work").should be_work
  end
end
