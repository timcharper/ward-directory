class Directory
  attr_reader :families
  
  def initialize(families = [])
    @families = families
  end
  
  def self.parse(content)
    lines = content.split("\n")
    pieces = []
    piece = nil
    lines[1..-1].each do |line|
      line = line + "\n"
      if /^[a-z]/i.match(line)
        pieces << (piece = line)
      else
        piece << line
      end
    end
    Directory.new(pieces.map { |p| Family.parse(p) })
  end
end