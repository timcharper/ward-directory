class Directory::Phone
  attr_reader :location
  
  def initialize(digits, location)
    @digits = digits
    @location = location
  end
  
  def to_s
    if location == 'home'
      formatted_phone
    else
      "#{location}: #{formatted_phone}"
    end
  end
  
  def formatted_phone
    if Directory.local_area_code && @digits[0..2] == Directory.local_area_code
      "#{@digits[3..5]}-#{@digits[6..9]}"
    else
      "(#{@digits[0..2]}) #{@digits[3..5]}-#{@digits[6..9]}"
    end
  end
  
  def work?
    @location == 'work'
  end
  
  def self.parse(phone_text)
    phone_text.match(/([a-z]+)/i)
    location = ($1 || 'home').strip
    digits = phone_text.gsub(/[^0-9]/, '')
    new(digits, location)
  end
end