class Directory::Individual
  attr_accessor :name, :is_parent, :gender, :birthday, :age, :email, :phone, :work_phone
  
  def initialize(name, is_parent, gender, birthday, age, contact_info = {})
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
end