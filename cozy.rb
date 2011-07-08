$:.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra'
require 'node'

ROOT_DIR = Dir.pwd+'/public'

require 'sinatra/base'

module Helpers
  def find_parent(type)
    parent = ROOT_DIR
    !(type == 'root') ? parent = File.join(ROOT_DIR,type) : nil
    parent
  end
end

class Cozy < Sinatra::Base
  include Helpers
end

class Protected < Cozy
  
  # create a new node
  get '/node/c/:type/:node' do
    parent = find_parent params[:type]
    @node = Node.new(params[:node], parent)
    @node.create
    "Created node \'#{@node.name}\' of type \'#{@node.type}\'"
  end


  # update a node
  get '/node/u/:type/:node/:content' do
    parent = find_parent params[:type]
    @node = Node.new(params[:node], parent)
    @node = Node.find(@node)
    unless @node.nil?
      @node.update File.join(parent,params[:node]), params[:content]
      "Updated node \'#{@node.name}\' of type \'#{@node.type}\'"
    else
      "Node \'#{params[:node]}\' of type \'#{params[:type]}\' not found."
    end
    
  end

  # delete a node
  get '/node/d/:type/:node' do
    parent = find_parent params[:type]
    @node = Node.new(params[:node], parent)
    @node = Node.find(@node)
    unless @node.nil?
      @node.delete File.join(parent, params[:node])
      Node.delete_parent_if_empty! parent  
      "Deleted node \'#{@node.name}\' of type \'#{@node.type}\'"
    else
      "Node \'#{params[:node]}\' of type \'#{params[:type]}\' not found."
    end
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

class Public < Cozy
  
  get '/' do
    erb :hello_world
  end
  
  # read a node
  get 'api/node/r/:name' do
    path = File.join(ROOT_DIR, params[:name])
    @node = Node.find(params[:name])
    @node.read path
  end

end