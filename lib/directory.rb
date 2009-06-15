# TODO - subclass specific behavior in to a subclass
class Directory
  attr_reader :families

  class << self
    attr_accessor :local_area_code, :photos_path
  end
  
  def initialize(families = [])
    @families = families
  end
  
  def match_photos(photo_filenames_or_folder = [])
    if photo_filenames_or_folder.is_a?(String)
      photo_filenames = Dir[File.expand_path(File.join(photo_filenames_or_folder, "*"))].grep(/(jpg|jpeg)$/i)
    else
      photo_filenames = photo_filenames_or_folder
    end
    
    indexed_photos = {}
    photo_filenames.each do |photo_filename|
      indexed_photos[File.basename(photo_filename).gsub(/.(jpg|jpeg)$/i, '').downcase] = photo_filename
    end
    families.each do |family|
      family_key = family.identifier
      indexed_photos.keys.each do |key|
        if family_key.include?(key)
          family.photo = indexed_photos.delete(key)
        end
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