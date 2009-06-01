require 'rubygems'
require 'spork'
require 'spec'
require 'spec/mocks'
load File.dirname(__FILE__) + "/../config/environment.rb"

Spork.prefork do
end

Spork.each_run do
  require File.dirname(__FILE__) + "/spec_helpers/mechanize_mock_helper.rb"
end