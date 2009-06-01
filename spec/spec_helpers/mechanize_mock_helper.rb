module MechanizeMockHelper
  def fixture_file(filename)
    File.read("#{ROOT_PATH}/spec/fixtures/#{filename}")
  end
  
  def mechanize_page(path_to_data, options = {})
    options[:uri] ||= URI.parse("http://url.com/#{path_to_data}")
    options[:response] ||= {'content-type' => 'text/html'}
  
    WWW::Mechanize::Page.new(options[:uri], options[:response], fixture_file(path_to_data))
  end
end