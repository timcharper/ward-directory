require 'rubygems'
require 'spork'
require 'spec'
require 'spec/mocks'
Spork.prefork do
  require File.dirname(__FILE__) + "/../config/environment.rb"
end

Spork.each_run do
  
end