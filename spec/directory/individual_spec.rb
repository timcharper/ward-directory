require File.dirname(__FILE__) + '/../spec_helper'

describe Directory::Individual do
  describe ".parse" do
    it "parses a parent's name, gender, and birthday info" do
      individual = Directory::Individual.parse("Dadimus	M	01 May	")
      individual.should be_parent
      individual.name.should == "Dadimus"
      individual.gender.should == "M"
      individual.birthday.should == "01 May"
      individual.age.should be_nil
    end
    
    it "parses a child's name, gender, age, and birthday info" do
      individual = Directory::Individual.parse("      Dan	M	01 Feb 1995	14")
      individual.should_not be_parent
      individual.name.should == "Dan"
      individual.gender.should == "M"
      individual.birthday.should == "01 Feb 1995"
      individual.age.should == 14
    end
  end
end
