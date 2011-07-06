require 'fileutils'
require 'rubygems'
require 'sinatra'

get '/' do
  erb :hello_world
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
<h1>
  Hello World!
</h1>