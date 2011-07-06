$:.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra'
require 'node'

ROOT_DIR = Dir.pwd+'/public'

require 'sinatra/base'

class Protected < Sinatra::Base

  # create a new node
  get '/node/new/:name' do
    @node = Node.new(params[:name])
    @node.create(@node.filename)
    "I created a new node called \'#{@node.name}\'"
  end



  # update a node
  get '/node/update/:name/:content' do
    filename = File.join(ROOT_DIR, params[:name])
    @node = Node.find(params[:name])
    @node.update filename, params[:content]
    "I updated the node \'#{@node.name}\'"
  end

  # delete a node
  get '/node/delete/:name' do
    filename = File.join(ROOT_DIR, params[:name])
    @node = Node.find(params[:name])
    @node.delete filename
    "I deleted the node \'#{@node.name}\'"
  end

  def self.app
    app = Rack::Auth::Digest::MD5.new(Protected.new) do |username|
      {'admin' => 'password'}[username]
    end
    app.realm = 'Protected Area'
    app.opaque = '07BDF0170AC2300BA73EF346B581D544'
    app
  end
end

class Public < Sinatra::Base

  get '/' do
    erb :hello_world
  end
  
  # read a node
  get '/node/:name' do
    filename = File.join(ROOT_DIR, params[:name])
    @node = Node.find(params[:name])
    @node.read filename
  end

end