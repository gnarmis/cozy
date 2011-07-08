#Cozy

This is an experiment that will try to implement a simple REST backend that uses the local filesystem for persistence.

- It will be based on Sinatra because Sinatra appears to support simple REST setups well.
- The basic CRUD operations will allow client-side javascript, which is properly authenticated, to interact with the local filesystem

##The Vision (so far)
Cozy intends to be a static RESTful backend that is general enough to support a number of clients. It is also quite experimental and is meant to be an exploration of ideas. It's a self-educational safari into the wild jungles of web frameworks, if you will.

##ToDo

- <del>make a simple read function with an associated model that interacts with the filesystem</del>
- <del>complete the basic CRUD operations</del>
- build some simple POST forms, at least for the update action (maybe split this off into a client that remains separate?)
- explore some clientside JS in this new client (backbone.js? probably not even that)
- <del>AUTH!</del> Added some basic HTTP auth (run it over SSL!)
- <del>can make directories</del>
- <del>incorporate some rspec magic</del>


##How to Run

Make sure you have the required gems and then run:

	ruby cozy.rb
	
To run rspec tests:

	rspec .