class Directory::Family
  attr_accessor :parents, :children, :surname, :address, :photo
  def initialize(options = {})
    options.each do |k, v|
      send("#{k}=", v)
    end
    @parents ||= []
    @children ||= []
  end
  
  def everyone
    @parents + @children
  end
  
  def feed_phone(phone)
    if phone.work?
      everyone.detect {|i| i.work_phones.empty? }.phones << phone
    else
      (everyone.detect {|i| i.phones.empty? } || everyone.first).phones << phone
    end
  end
  
  def feed_email(email)
    everyone.detect {|i| i.email.nil? }.email = email
  end
  
  def self.parse(text)
    family = new
    
    people_lines = []
    info_lines = []
    text.split("\n").each do |line|
      info_line, people_line = line.split("\t", 2)
      info_lines << info_line if info_line
      people_lines << people_line if people_line
    end
    
    family.surname = info_lines[0].strip
    
    people_lines.each do |line|
      individual = Directory::Individual.parse(line)
      next unless individual
      if individual.parent?
        family.parents << individual
      else
        family.children << individual
      end
    end
    
    address_lines = []
    info_lines[1..-1].each do |line|
      case line
      when /(.+\@.+?) +(.+[0-9].+)/
        family.feed_email($1.strip)
        family.feed_phone(Directory::Phone.parse($2.strip))
      when /\@/
        family.feed_email(line.strip)
      when /[0-9]{3}-[0-9]{4}/
        family.feed_phone(Directory::Phone.parse(line))
      else
        address_lines << line
      end
    end
    family.address = Directory::Address.parse(address_lines)
    family
  end
end