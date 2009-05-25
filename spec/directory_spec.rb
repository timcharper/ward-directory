require File.dirname(__FILE__) + '/spec_helper'

describe Directory do
  before(:each) do
    @example_listing = <<-EOF    
Household	Given Name	Sex	Birth Date	Age
Charleson	Dixie	F	05 Mar	
      16 S. Village Court Road	 	 	 	 
      Saratoga Springs, UT  84045	 	 	 	 
Chewey	Sue	F	04 Oct	
      2133 S Silver Fox Circle	 	 	 	 
      Saratoga Springs, UT  84045	 	 	 	 
      801-756-1768	 	 	 	 
EOF
  end
  
  it "parses a block of families" do
    directory = Directory.parse(@example_listing)
    directory.should have(2).families
    directory.families.map(&:surname).should == %w[Charleson Chewey]
  end
  
  it "matches a list of photos to families" do
    directory = Directory.parse(@example_listing)
    unused_photos = directory.match_photos(["/photos/Charleson, Dixie.jpg", "/photos/Chewey, Sue.jpg", "/photos/Guy, Some.jpg"])
    unused_photos.should == ["/photos/Guy, Some.jpg"]
    directory.families[0].photo.should == "/photos/Charleson, Dixie.jpg"
    directory.families[1].photo.should == "/photos/Chewey, Sue.jpg"
  end
end
