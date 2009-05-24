require File.dirname(__FILE__) + '/../spec_helper'

describe Directory::Address do
  it "parses and address" do
    address = Directory::Address.parse("      444 W Fox Hollow Drive", "      Saratoga Springs, UT  84045")
    address.street.should == "444 W Fox Hollow Drive"
    address.city.should == "Saratoga Springs"
    address.state.should == "UT"
    address.zip.should == "84045"
  end
end
