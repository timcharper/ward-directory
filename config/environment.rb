require 'rubygems'
require 'pp'
require 'activesupport'
ROOT_PATH = File.expand_path('../', File.dirname(__FILE__))
ActiveSupport::Dependencies.hook!
ActiveSupport::Dependencies.load_paths << (ROOT_PATH + "/lib")
