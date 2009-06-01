require File.dirname(__FILE__) + '/../spec_helper'

describe Directory::Family do
  describe ".parse" do
    it "parses a block of text for a family" do
      @family = Directory::Family.parse <<-EOF
Hunter	Dadimus	M	01 May	
      123 W Fox Hollow Drive	Momimus	F	01 Sep	
      Saratoga Springs, UT  84045	      Kim	F	01 Jun	
      hunters@email.com	      Stephanie	F	01 Jan 1992	17
      (111) 111-1111	      Dan	M	01 Feb 1995	14
      (222) 222-2222	      Michelle	F	01 Jun 1998	10
 	      Chandra	F	01 May 2001	8
 	      Jo Jo	M	01 Jan 2003	6
 	      Dayne	M	01 Feb 2005	4
EOF
      @family.surname.should == "Hunter"
      @family.address.street.should == "123 W Fox Hollow Drive"
      @family.address.city.should == "Saratoga Springs"
      @family.address.state.should == "UT"
      @family.address.zip.should == "84045"
      
      @family.should have(2).parents
      @family.should have(7).children
      @family.parents.map(&:name).should == %w[Dadimus Momimus]
      @family.children.map(&:name).should == %w[Kim Stephanie Dan Michelle Chandra Jo\ Jo Dayne]
      
      @family.parents[0].email.should == "hunters@email.com"
      @family.parents[0].phone.to_s.should == "(111) 111-1111"
      @family.parents[1].phone.to_s.should == "(222) 222-2222"
    end
    
    it "properly handles families with one parent" do
      @family = Directory::Family.parse <<-EOF
Tanner	Dan	M	12 Jan	
      1532 Silver Fox Lane	      Barbara	F	16 Aug 1996	12
      Saratoga Springs, UT  84043	      Billy	M	19 May 1999	10
      fanning@email.com  (111) 111-1111	      Georgia	F	31 Dec 2002	6
      (222) 222-2222	 	 	 	 
      (333) 333-3333	 	 	 	 
EOF
      @family.should have(1).parents
      @family.should have(3).children
      @family.parents[0].email.should == "fanning@email.com"
      @family.parents[0]. phone.to_s.should == "(111) 111-1111"
      @family.children[0].phone.to_s.should == "(222) 222-2222"
      @family.children[1].phone.to_s.should == "(333) 333-3333"
    end
    
    it "handles work numbers" do
      @family = Directory::Family.parse <<-EOF
Tanner	Dan	M	12 Jan	
      1532 Silver Fox Lane	      Barbara	F	16 Aug 1996	12
      Saratoga Springs, UT  84043	      Billy	M	19 May 1999	10
      fanning@email.com  (111) 111-1111	      Georgia	F	31 Dec 2002	6
      (222) 222-2222 work	 	 	 	 
      (333) 333-3333	 	 	 	 
EOF
      @family.parents[0].phone.to_s.should == "(111) 111-1111"
      @family.parents[0].work_phone.to_s.should == "work: (222) 222-2222"
      @family.children[0].phone.to_s.should == "(333) 333-3333"
    end
    
    it "handles missing addresses" do
      @family = Directory::Family.parse <<-EOF
Anderson	Kenneth Paul	M	09 Dec	
      Saratoga Springs, UT  84045      
EOF
      @family.surname.should == "Anderson"
      @family.address.street.should == ""
      @family.address.city.should == "Saratoga Springs"
      @family.address.state.should == "UT"
      @family.address.zip.should == "84045"
    end
    
    it "handles families with more phones than people" do
      @family = Directory::Family.parse <<-EOF
Casa	Hombre	M	01 Sep	
      1234 S. Wildflower Dr.	 	 	 	 
      Saratoga Springs, UT  84045	 	 	 	 
      111-111-1111	 	 	 	 
      222 222-2222 (hombre)	 	 	 	 
EOF
      @family.surname.should == "Casa"
      @family.should have(1).parent
      @family.parents[0].should have(2).phones
    end
  end
  
  describe ".digest_info_items" do
    def parse_items(items)
      Directory::Family.digest_info_items(items)
    end
    
    it "should recognize two emails on a line" do
      parse_items(["e1@email.com, e2@email.com"]).should == ['e1@email.com', 'e2@email.com']
      parse_items(["e1@email.com  e2@email.com"]).should == ['e1@email.com', 'e2@email.com']
      parse_items(["  e1@email.com    e2@email.com"]).should == ['e1@email.com', 'e2@email.com']
    end
    
    it "should recognize a phone number with a location suffix and an email" do
      parse_items(["(111) 111-1111 (work)  e1@email.com"]).should == ['(111) 111-1111 (work)', 'e1@email.com']
      parse_items(["111-111-1111 (work)  e1@email.com"]).should == ['111-111-1111 (work)', 'e1@email.com']
      parse_items(["111-1111 (work)  e1@email.com"]).should == ['111-1111 (work)', 'e1@email.com']
      
      parse_items(["e1@email.com  (111) 111-1111 (work)"]).should == ['e1@email.com', '(111) 111-1111 (work)']
      parse_items(["e1@email.com  111-111-1111 (work)"]).should == ['e1@email.com', '111-111-1111 (work)']
      parse_items(["e1@email.com  111-1111 (work)"]).should == ['e1@email.com', '111-1111 (work)']
    end
    
    it "should recognize 2 phone numbers on the same line" do
      parse_items(["(111) 111-1111 (home) (222) 222-2222 (work)"]).should == ["(111) 111-1111 (home)", "(222) 222-2222 (work)"]
    end
  end
end
