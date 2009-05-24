class Directory::Address
  attr_accessor :street, :city, :state, :zip
  
  def initialize(street, city, state, zip)
    @street, @city, @state, @zip = street, city, state, zip
  end
  
  def self.parse(address_text, city_state_zip_text)
    /(.+), ([A-Z]{2})  ([0-9-]+)/.match(city_state_zip_text)
    new(address_text.strip, $1.strip, $2.strip, $3.strip)
  end
end