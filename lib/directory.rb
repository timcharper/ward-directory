class Directory
  attr_reader :families

  class << self
    attr_accessor :local_area_code, :photos_path
  end
  
  def initialize(families = [])
    @families = families
  end
  
  def match_photos(photo_filenames = [])
    indexed_photos = {}
    photo_filenames.each do |photo_filename|
      indexed_photos[File.basename(photo_filename).gsub(/.(jpg|jpeg)$/i, '').downcase] = photo_filename
    end
    families.each do |family|
      key = "#{family.surname}, #{family.parents.first.name}".downcase
      if indexed_photos[key]
        family.photo = indexed_photos.delete(key)
      end
    end
    indexed_photos.values.sort
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