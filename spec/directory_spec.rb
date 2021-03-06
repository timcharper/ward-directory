require File.dirname(__FILE__) + '/spec_helper'

describe Directory do
  EXAMPLE_LISTING = <<-EOF
Household	Given Name	Sex	Birth Date	Age
Charleson	Dixie T	F	05 Mar	
      16 S. Village Court Road	 	 	 	 
      Saratoga Springs, UT  84045	 	 	 	 
Chewey	Sue	F	04 Oct	
      2133 S Silver Fox Circle	 	 	 	 
      Saratoga Springs, UT  84045	 	 	 	 
      801-756-1768	 	 	 	 
EOF
  
  it "parses a block of families" do
    directory = Directory.parse(EXAMPLE_LISTING)
    directory.should have(2).families
    directory.families.map(&:surname).should == %w[Charleson Chewey]
  end
  
  it "skips over 'see such and such' lines" do
    directory = Directory.parse(EXAMPLE_LISTING + "Person, Awesome, see Chewey, Sue\n")
    directory.should have(2).families
  end

  it "matches a list of photos to families" do
    directory = Directory.parse(EXAMPLE_LISTING)
    unused_photos = directory.match_photos(["/photos/Charleson, Dixie.jpg", "/photos/Chewey, Sue.jpg", "/photos/Guy, Some.jpg"])
    unused_photos.should == ["/photos/Guy, Some.jpg"]
    directory.families[0].photo.should == "/photos/Charleson, Dixie.jpg"
    directory.families[1].photo.should == "/photos/Chewey, Sue.jpg"
  end
  
  it "matches a list of photos from in a folder to families" do
    directory = Directory.parse(EXAMPLE_LISTING)
    Dir.should_receive(:[]).with('/folder/*').and_return(["/photos/Charleson, Dixie.jpg", "/photos/Chewey, Sue.Jpg", "/photos/Guy, Some.JPEG"])
    unused_photos = directory.match_photos('/folder')
    unused_photos.should == ["/photos/Guy, Some.JPEG"]
    directory.families[0].photo.should == "/photos/Charleson, Dixie.jpg"
    directory.families[1].photo.should == "/photos/Chewey, Sue.Jpg"
  end
end
