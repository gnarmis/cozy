require File.join(File.dirname(__FILE__), '..', 'cozy.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'

# set test environment
set :environment, :test

ROOT_DIR = Dir.pwd+'/public'

def clean!
  pubdir = ROOT_DIR #defined in cozy.rb
  FileUtils.rm_rf pubdir
  FileUtils.mkdir pubdir
end

RSpec.configure do |config|
  config.before(:each) { clean! }
end
