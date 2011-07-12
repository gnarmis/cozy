require File.join(File.dirname(__FILE__), '..', 'cozy.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'

# set test environment
set :environment, :test
# other constants defined in cozy.rb

TEST_DIR = Dir.pwd + '/public_test'
ROOT_DIR = TEST_DIR

def clean!
  pubdir = TEST_DIR
  FileUtils.rm_rf pubdir
  FileUtils.mkdir pubdir
end

RSpec.configure do |config|
  config.before(:each) { clean! }
  config.after(:each) do
    clean!
    FileUtils::rmdir TEST_DIR
  end
end
