require 'fileutils'

class Node < Object
  attr_reader :name, :filename, :read, :update, :delete

  include FileUtils
  
  def initialize(name)
    @name ||= name
    @filename = File.join(ROOT_DIR, @name)
  end
  
  def create(filename)
    touch filename
  end
  
  def read(filename)
    if File.exists? filename
      content = File.open(filename, 'r')
    else
      "Not Found"
    end
  end
  
  def update(filename, newcontent='')
    File.open(filename, 'w') {|f| f.write(newcontent)}
  end
  
  def delete(filename)
    rm filename
  end
  
  def self.find(name)
    entries = Dir.entries(ROOT_DIR)
    if entries.member? name
      Node.new(name)
    else
      nil
    end
  end
  
end