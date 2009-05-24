require File.dirname(__FILE__) + '/spec_helper'

describe Directory do
  it "parses a block of families" do
    directory = Directory.parse <<-EOF    
Household	Given Name	Sex	Birth Date	Age
Charleson	Dixie T	F	05 Mar	
      16 S. Village Court Road	 	 	 	 
      Saratoga Springs, UT  84045	 	 	 	 
Chewey	Sue	F	04 Oct	
      2133 S Silver Fox Circle	 	 	 	 
      Saratoga Springs, UT  84045	 	 	 	 
      801-756-1768	 	 	 	 
EOF
    directory.should have(2).families
    directory.families.map(&:surname).should == %w[Charleson Chewey]
  end
end
