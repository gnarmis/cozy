require File.dirname(__FILE__) + '/spec_helper'

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
end