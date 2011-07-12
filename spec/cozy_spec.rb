require File.dirname(__FILE__) + '/spec_helper'
require 'fileutils'

describe "Cozy" do
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end
  
  it "should respond to /" do
    get '/'
    last_response.status.should == 200
  end
  
  it "should return the correct content-type when viewing root" do
    get '/'
    last_response.headers["Content-Type"].should == "text/html;charset=utf-8"
  end
  
  it "should return 404 when page cannot be found" do
    get '/404'
    last_response.status.should == 404
  end
  
  it "should return 'Hello World!' when viewing root" do
    get '/'
    last_response.body.should == "Hello World!"
  end
  
  it "should return 401 when trying to create node" do
    get '/node/c/example/example'
    last_response.status.should == 401
  end
  
  it "should return 401 when trying to update node" do
    get '/node/u/example/example/example'
    last_response.status.should == 401
  end
  
  it "should return 200 when trying to read node" do
    get '/node/c/example/example'
    get '/node/r/example/example'
    last_response.status.should == 200
  end
  
  # the following tests are for the refactored code
  
  it "should respond to GET /types" do
    get '/types'
    last_response.status.should == 200
  end
  
  it "should respond to GET /nodes" do
    get '/nodes'
    last_response.status.should == 200
  end
  
  it "should return array as a string with all types for GET /types" do
    FileUtils::mkdir File.join(ROOT_DIR,'a')
    FileUtils::mkdir File.join(ROOT_DIR,'b')
    FileUtils::touch File.join(ROOT_DIR,'b/foo.html')
    FileUtils::touch File.join(ROOT_DIR,'bar.html')
    get '/types'
    last_response.body.should == '["a", "b"]'
  end
  
  it "should return hash as a string with all nodes for GET /nodes" do
    FileUtils::mkdir File.join(ROOT_DIR,'a')
    FileUtils::mkdir File.join(ROOT_DIR,'b')
    FileUtils::touch File.join(ROOT_DIR,'b/foo.html')
    FileUtils::touch File.join(ROOT_DIR,'bar.html')
    get '/nodes'
    last_response.body.should == '{"root"=>["bar.html"], "b"=>["foo.html"]}'    
  end
  
  it "should respond to GET /nodes/:type/:node" do
    FileUtils::mkdir File.join(ROOT_DIR,'b')
    FileUtils::touch File.join(ROOT_DIR,'b/foo.html')
    get '/nodes/b/foo.html'
    last_response.status.should == 200
  end
  
  it "should return specified node for GET /nodes/:type/:node" do
    FileUtils::mkdir File.join(ROOT_DIR,'b')
    FileUtils::touch File.join(ROOT_DIR,'b/foo.html')
    File.open(File.join(ROOT_DIR,'b/foo.html'), 'w') {|f| f.write('new content')}
    get '/nodes/b/foo.html'
    last_response.body.should == 'new content'
  end
  
  it "should successfully create a new node for POST /nodes" do
    authorize USERNAME, PASSWORD
    post '/nodes', {:type=>"root", :node => "foo.html"}
    last_response.status.should == 200
  end
end