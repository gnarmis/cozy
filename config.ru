$:.unshift File.expand_path(File.dirname(__FILE__))

require 'cozy'
 
run Rack::URLMap.new({
  "/" => Public.new,
  "/" => Protected.app
})