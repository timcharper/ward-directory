class Directory::Address
  attr_accessor :street, :city, :state, :zip
  
  def initialize(street, city = "", state = "", zip = "")
    @street, @city, @state, @zip = street, city, state, zip
  end
  
  def self.parse(parts)
    if parts.length == 1
      street = ""
      city_state_zip_text = parts[0]
    else
      street, city_state_zip_text = parts
    end
    
    case city_state_zip_text
    when /(.+), ([A-Z]{2})  ([0-9-]+)/
      new(street.strip, $1.strip, $2.strip, $3.strip)
    when /(.+)  ([0-9-]+)/
      new(street.strip, $1.strip, "", $2.strip)
    else
      new(street.to_s.strip)
    end
  end
end