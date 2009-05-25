require File.dirname(__FILE__) + '/../spec_helper'

describe Array do
  describe "#each_with_index" do
    it "iterates yielding the index" do
      indices = []
      values = []
      [1,2,3].each_with_index do |value, index|
        values << value
        indices << index
      end
      values.should == [1,2,3]
      indices.should == [0,1,2]
    end
  end
end
