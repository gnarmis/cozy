require File.dirname(__FILE__) + '/spec_helper'
require 'fileutils'

describe "Cozy" do
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end
  
  
  it "should return the correct content-type when viewing root" do
    get '/'
    last_response.headers["Content-Type"].should == "text/html;charset=utf-8"
  end
  
  it "should respond to GET /types" do
    get '/types'
    last_response.status.should == 200
  end
  
  it "should respond to GET /nodes" do
    get '/nodes'
    last_response.status.should == 200
  end
  
  it "should return array as a string with all types for GET /types" do
    FileUtils::mkdir File.join(TEST_DIR,'a')
    FileUtils::mkdir File.join(TEST_DIR,'b')
    FileUtils::touch File.join(TEST_DIR,'b/foo.html')
    FileUtils::touch File.join(TEST_DIR,'bar.html')
    get '/types'
    last_response.body.should == '["a", "b"]'
  end
  
  it "should return hash as a string with all nodes for GET /nodes" do
    FileUtils::mkdir File.join(TEST_DIR,'a')
    FileUtils::mkdir File.join(TEST_DIR,'b')
    FileUtils::touch File.join(TEST_DIR,'b/foo.html')
    FileUtils::touch File.join(TEST_DIR,'bar.html')
    get '/nodes'
    last_response.body.should == '{"root"=>["bar.html"], "b"=>["foo.html"]}'    
  end
  
  it "should respond to GET /nodes/:type/:node" do
    FileUtils::mkdir File.join(TEST_DIR,'b')
    FileUtils::touch File.join(TEST_DIR,'b/foo.html')
    get '/nodes/b/foo.html'
    last_response.status.should == 200
  end
  
  it "should return specified node for GET /nodes/:type/:node" do
    FileUtils::mkdir File.join(TEST_DIR,'b')
    FileUtils::touch File.join(TEST_DIR,'b/foo.html')
    File.open(File.join(TEST_DIR,'b/foo.html'), 'w') {|f| f.write('new content')}
    get '/nodes/b/foo.html'
    last_response.body.should == 'new content'
  end
  
  it "should successfully create a new node for POST /nodes" do
    authorize USERNAME, PASSWORD
    post '/nodes', {:type=>"root", :node => "foo.html"}
    last_response.status.should == 200
  end
  
  it "should successfully update an existing node for PUT /nodes" do
    authorize USERNAME, PASSWORD
    FileUtils::touch File.join(TEST_DIR,'foo.html')
    File.open(File.join(TEST_DIR,'foo.html'), 'w') {|f| f.write('old content')}
    put '/nodes', {:type => "root", :node => "foo.html", :content => "new content"}
    last_response.status.should == 200
    last_response.body.should == "Updated node 'foo.html' of type 'public_test'"
    get '/nodes/root/foo.html'
    last_response.body.should == "new content"
  end
  
  it "should successfully delete an existing node for DELETE /nodes" do
    authorize USERNAME, PASSWORD
    FileUtils::touch File.join(TEST_DIR,'foo.html')
    delete '/nodes', {:type => 'root', :node => 'foo.html'}
    last_response.status.should == 200
  end
  
  it "should create a new node even when no public/ dir is present" do
    authorize USERNAME, PASSWORD
    FileUtils::rmdir TEST_DIR
    post '/nodes', {:type => 'root', :node => 'foot.html'}
    last_response.status.should == 200
  end
  
  it "should not create a new node without authorization" do
    post '/nodes', {:type=>"root", :node => "foo.html"}
    last_response.status.should == 401
  end
  
  it "should not update an existing node without authorization" do
    FileUtils::touch File.join(TEST_DIR,'foo.html')
    File.open(File.join(TEST_DIR,'foo.html'), 'w') {|f| f.write('old content')}
    put '/nodes', {:type => "root", :node => "foo.html", :content => "new content"}
    last_response.status.should == 401
  end
  
  it "should not delete an existing node without authorization" do
    FileUtils::touch File.join(TEST_DIR,'foo.html')
    delete '/nodes', {:type => 'root', :node => 'foo.html'}
    last_response.status.should == 401
  end
  
  # it "should route GET /nodes/:type/:node to GET /:type/:node" do
  #   FileUtils::mkdir File.join(TEST_DIR,'a')
  #   FileUtils::touch File.join(TEST_DIR,'a/foo.html')
  #   File.open(File.join(TEST_DIR,'a/foo.html'), 'w') {|f| f.write('some content')}
  #   get '/a/foo.html'
  #   last_response.body.should == 'some content'
  # end
end