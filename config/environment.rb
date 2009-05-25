require 'rubygems'
require 'spork'

Spork.prefork do
  require 'pp'
  require 'activesupport'

  ROOT_PATH = File.expand_path('../', File.dirname(__FILE__))
  ActiveSupport::Dependencies.hook!
  ActiveSupport::Dependencies.load_paths << (ROOT_PATH + "/lib")
  $:.unshift(ROOT_PATH + "/lib")
end

Spork.each_run do
  require 'ext/array'
end
