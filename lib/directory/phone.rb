class Directory::Phone
  attr_reader :location
  
  def initialize(digits, location)
    @digits = digits
    @location = location
  end
  
  def to_s
    case location
    when 'home'
      formatted_phone
    when 'work'
      "#{location[0..0]}: #{formatted_phone}"
    else
      "#{location}: #{formatted_phone}"
    end
  end
  
  def formatted_phone
    "(#{@digits[0..2]}) #{@digits[3..5]}-#{@digits[6..9]}"
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