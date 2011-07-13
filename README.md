#Cozy

Cozy is a simple REST backend that uses the local filesystem for persistence. There is also a simple JS client (in development) to interact with this layer.

- Based on Sinatra
- The basic CRUD operations allow client-side javascript, which is properly authenticated, to interact with the local filesystem

##Cozy CMS?

There are several great solutions in the "light CMS" category, like Perch, Unify, Pulse, etc. There is some scope for a light CMS that leaves your static site completely unchanged and pluggable, while exposing a browser-based interface if needed. With the other solutions, you need to at the very least add some CSS attributes on the DIV you want to edit, and not all of them support adding/removing files. This is a niche Cozy CMS could fill.

Basically, Cozy CMS could allow for any static site to be developed and be worked on using a browser-based client and then Cozy CMS could be discarded, leaving only the contents of the public/ folder.

##REST API
The API is in flux right now, but here are the current routes. Check spec/cozy_spec.rb for a closer look at the functionality tests and of course cozy.rb for just the routes.

	Unprotected Requests
	
	GET '/types' => list of node types
	GET '/nodes' => list of nodes, by type
	
	Protected Requests
	
	POST '/nodes', params[:type, :node] 					=> create a node
	PUT '/nodes', params[:type, :node, :content] 	=> update a node
	DELETE '/nodes', params[:type, :node] 				=> delete a node
 
##ToDo

- <del>make a simple read function with an associated model that interacts with the filesystem</del>
- <del>complete the basic CRUD operations</del>
- build some simple POST forms, at least for the update action (maybe split this off into a client that remains separate?)
- explore some clientside JS in this new client (backbone.js? probably not even that)
- <del>AUTH!</del> Added some basic HTTP auth (run it over SSL!)
- <del>can make directories</del>
- <del>incorporate some rspec magic</del>
- <del>start using rspec to document behavior</del>
- <del>use HTTP verbs and refactor previous code</del>


##How to Run

Make sure you have the required gems and then run:

	ruby cozy.rb
	
To run rspec tests (the tests don't touch the public/ directory at all):

	rspec .