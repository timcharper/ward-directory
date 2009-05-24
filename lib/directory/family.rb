class Directory::Family
  attr_accessor :parents, :children, :surname, :address
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
      everyone.detect {|i| i.work_phone.nil? }.work_phone = phone
    else
      everyone.detect {|i| i.phone.nil? }.phone = phone
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
      line.match(/^(.+?)\t(.+)$/)
      info_lines << $1
      people_lines << $2
    end
    
    family.surname = info_lines[0].strip
    family.address = Directory::Address.parse(info_lines[1], info_lines[2])
    
    people_lines.each do |line|
      individual = Directory::Individual.parse(line)
      next unless individual
      if individual.parent?
        family.parents << individual
      else
        family.children << individual
      end
    end
    
    emails = []
    phones = []
    info_lines[3..-1].each do |line|
      case line
      when /(.+\@.+?) +(.+[0-9].+)/
        family.feed_email($1.strip)
        family.feed_phone(Directory::Phone.parse($2.strip))
      when /\@/
        family.feed_email(line.strip)
      else
        family.feed_phone(Directory::Phone.parse(line))
      end
    end
    
      
    family
  end
end