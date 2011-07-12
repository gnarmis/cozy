$:.unshift File.expand_path(File.dirname(__FILE__))
require 'node'
require 'rubygems'
require 'haml'
require 'sinatra'
require 'fileutils'

ROOT_DIR = Dir.pwd+'/public'
USERNAME = 'cozy'
PASSWORD = 'cozy'
require 'sinatra/base'

helpers do
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['cozy', 'cozy']
  end
  
  def find_parent(type)
    parent = ROOT_DIR
    !(type == 'root') ? parent = File.join(ROOT_DIR,type) : nil
    parent
  end
end

# Code refactoring: use HTTP verbs for CRUD operations to make it actually RESTful
# Also, rspec can be used to document behavior of REST requests, and drive future dev

# the following is the refactored code

# get index of all types
get '/types' do
  Node.get_types.to_s
end

# get index of all nodes
get '/nodes' do
  Node.get_nodes.to_s
end

# get a specific node
get '/nodes/:type/:node' do
  parent = find_parent params[:type]
  @node = Node.new(params[:node], parent)
  @node = Node.find(@node)
  unless @node.nil?
    @node.read File.join(parent,params[:node])
  else
    "Node \'#{params[:node]}\' of type \'#{params[:type]}\' not found."
  end
end

# create a node
post '/nodes' do
  protected!
  parent = find_parent params[:type]
  @node = Node.new(params[:node], parent)
  @node.create
  "Created node \'#{@node.name}\' of type \'#{@node.type}\'"
end

# the following is older code that needs to be refactored

# create a new node
get '/node/c/:type/:node' do
  protected!
  parent = find_parent params[:type]
  @node = Node.new(params[:node], parent)
  @node.create
  "Created node \'#{@node.name}\' of type \'#{@node.type}\'"
end


# update a node
get '/node/u/:type/:node/:content' do
  protected!
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
  protected!
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

# def self.app
#   app = Rack::Auth::Digest::MD5.new(Protected.new) do |username|
#     {'admin' => 'password'}[username]
#   end
#   app.realm = 'Protected Area'
#   app.opaque = '07BDF0170AC2300BA73EF346B581D544'
#   app
# end


get '/' do
  "Hello World!"
end

# read a node
get '/node/r/:type/:node' do
  parent = find_parent params[:type]
  @node = Node.new(params[:node], parent)
  @node = Node.find(@node)
  unless @node.nil?
    @node.read File.join(parent,params[:node])
  else
    "Node \'#{params[:node]}\' of type \'#{params[:type]}\' not found."
  end
end
