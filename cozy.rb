require 'rubygems'
require 'sinatra'
require './node.rb'

ROOT_DIR = Dir.pwd+'/public'

get '/' do
  erb :hello_world
end

# create a new node
get '/node/new/:name' do
  @node = Node.new(params[:name])
  @node.create(@node.filename)
  "I created a new node called \'#{@node.name}\'"
end

# read a node
get '/node/:name' do
  filename = File.join(ROOT_DIR, params[:name])
  @node = Node.find(params[:name])
  @node.read filename
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

__END__

@@layout
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<title>Title</title>
	<!--
	<link rel="stylesheet" type="text/css" href="stylesheets/app.css" />
	<script type="text/javascript" src="scripts/app.js"></script>
	-->
	<!--[if IE]>
		<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
</head>
<body id="home">
  <%= yield %>
</body>
</html>

@@hello_world
<h1>Hello World!</h1>