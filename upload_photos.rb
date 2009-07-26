unless ARGV.length == 1
  puts "Usage: #{$0} [/path/to/photos]"
  exit! 1
end

require 'config/environment.rb'
config = YAML.load_file(File.dirname(__FILE__) + '/config/ward_website.yml')

photo_directory = ARGV[0] || "~/Pictures/WardDirectoryPhotos"
web_directory = WebDirectory.new(config)
unused_photos = web_directory.match_photos(photo_directory)
web_directory.families.each do |f|
  next unless f.photo
  puts "Uploading #{f.photo}"
  f.upload_photo
end
puts "Didn't use the following photos:"
puts unused_photos * "\n"