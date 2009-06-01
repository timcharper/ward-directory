class Directory::Individual
  attr_accessor :name, :is_parent, :gender, :birthday, :age, :email, :phones
  
  def initialize(name, is_parent = true, gender = nil, birthday = nil, age = nil, contact_info = {})
    self.phones = []
    self.name, self.is_parent, self.gender, self.birthday, self.age = name, is_parent, gender, birthday, age
  end
  
  def age=(value)
    @age = value ? value.to_i : nil
  end
  
  def self.parse(text)
    name, gender, birthday, age = text.split("\t").map(&:strip)
    return nil if name.blank?
    is_parent = text[0..0] != " "
    age = nil if age.blank?
    new(name, is_parent, gender, birthday, age)
  end
  
  def parent?
    @is_parent
  end
  
  def work_phones
    phones.select { |p| p.work? }.freeze
  end
  
  def phone
    phones.first
  end
  
  def work_phone
    work_phones.first
  end
end