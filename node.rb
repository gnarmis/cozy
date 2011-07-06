require 'fileutils'

class Node < Object
  attr_reader :name, :filename
  
  include FileUtils
  
  def initialize(name)
    @name = name
    @filename = File.join(ROOT_DIR, @name)
  end
  
  def create(name)
    touch name
  end
  
end