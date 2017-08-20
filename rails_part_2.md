# Rails Part 2

## API
- Application Programming Interface: Published set of rules for how a particular piece of software works and how you use it.
- Example: In our ruby objects, the API of a ruby object is just the public available methods on that object (public methods).
- In rails, the API is going to be HTTP routes.
- If we had a rails application, a part of our API might be that if we made a `get` request to cats, it would give back a bunch of cat pictures.
- A website is what we see on the internet via the browser. If we search up google, our request goes to a server and we `get` back HTML, CSS, JS, some images, assets, etc. which the browser will render.
- A web service (sometimes called API) gives us back raw data instead of HTML, etc.
- Let's say we made a `get` request to foods, and it gives us back a list of food (without any style, just data) in JSON format or others.
- The website includes assets to be rendered by the browser while the web service is just data.
- Let's say we are using google maps on our phone. Our phone knows how to render but it needs data about where things are, etc. The phone hits some web service where it will just `get` back some data. More examples are server to server communication (NETFLIX) and client side rendering of data (single page application [SPA]). An example of client side rendering is gmail where you never leave the site when you go through inbox etc, but rather gmail uses a web service to `get` the information you want.

## HTTP Request and Response
- When you are a client (user on a laptop) and you are communication to a server, you make a HTTP request and you `get` back a HTTP response. Think of it like writing letters to each other.
- The **request** has:
  - A method, including `get`, `PUT`, `PATCH`, `POST`, etc.
  - A path, example being `/users/4`.
  - A query (optional) which can be seen in URLs like a URL from youtube with a query string, `?loc=SF&name=`. These are key value pairs which are separated by `=` and the pairs themselves are separated by `&`.
  - A request body (optional) which is also key value pairs. This would usually come from something like a form. For example, if we had a page that made us write in our email, password, age, etc, these would be put into the body of a request. Essentially additional data that you are packaging along. You can't have request bodies in `get` requests.  
- The **response** has:
  - A status which tells you about what happened on the server when it tried to process the request. If things are ok, you might get back something like `200 OK`. Or not, `404 NOT FOUND`.
  - A body which is the main chunk of what came back in this response. If you made a request to get a list of all the users, your body is going to be the list of all those users. If you made a request to get an actual website, the body would contain all of the HTML, JS, etc needed to render the website.  

## Rails Routing
- An HTTP request comes, received by rails, and first hits the router.
- The router is something in rails that is supposed to determine, who should I send this too?
- The router will take into consideration the path of the request and the method of the request. The path could be `/users` and the method could be `get` to get the users.
- The router has a list of combinations of paths and methods that are associated with which controllers and the actions of those controllers.
- It is also the router's job to tell the controller what it needs to do to process this request.
- Controllers are responsible for controlling one resource. We can have a class, `UsersController` whose job is to figure out how to process requests that are about users.
- Controllers have things called actions which are methods defined in the controllers like
```ruby
class UsersController
  def index
  end
end
```
- The router, when it matches the path and the method (check routes), will initialize a new instance of `UsersController` and call the right action.
- The `UsersController` is now responsible to actually fill out a HTTP response and give it back.
- We give directions to the router via the `routes.rb` file.  
- If the router can't find a matching route for the path and method, we would get an error screen.
- [**OVERVIEW**](https://blog.chattyhive.com/wp-content/uploads/2014/01/mvc_detailed-full.png) (link)
  - When the browser makes the request, it first hits the rails router which determines which controller the request will be processed by and which actions it will call on the controller.
  - The controller would then leverage a view or model (if it needs to) and get some information from the database which it will take and either directly give back information (like JSON) or dynamically generated HTML (via Rails View) based on some information we getting out of our database.
  - The controller would then populate an HTTP response and give it back to the client that made the request.

## Routes Demo
- Inside the `routes.rb` in the path `config/locales`:
```ruby
Rails.application.routes.draw do
  # get 'superheroes', to: 'superheroes#index'
  # get 'superheroes/:id', to: 'superheroes#show'
  # post 'superheroes', to: 'superheroes#create'
  # patch 'superheroes/:id', to: 'superheroes#update'
  # put 'superheroes/:id', to: 'superheroes#update'
  # delete 'superheroes/:id', to: 'superheroes#destroy'

  # Can all be created with:
  # resources: superheroes, only: [:index, :show, :create, :update, :destroy]

  resources :superheroes do
    resources :abilities, only: [:index]
  end

  #  If we wanted to create a route, get 'superheroes/2/abilities', we would pass in a block to this call to resources superheroes, and inside of that block block, we would have another call to resources abilities which will create a nested structure like 'superheroes/2/abilities', where these restful resourceful routes will be nested under superheroes.

  resources :abilities, only: [:show, :update, :create, :destroy]
end
```
- This uses a DSL (domain specific language) to define the routes.
- Basic format for defining a route: You write the name of the HTTP method (aka verb), `get` etc., and then you specify the path that this should match, `superheroes`. If it matches, you need to specify what controller, and what controller action, should process the request. You do that by passing in a hash, `to: 'superheroes#index'`, where `superheroes` is the name of the controller, followed by a `#`, followed by the name of the action, `index`.
- The convention we will use for routes is REST (representational state transfer) which is an agreed upon way of specifying these routes so people can trust that it is going to do the same thing across applications.
- If you have a `get` request for some name like `superheroes`, conventionally, that should return all of the values for that resource. The rails convention for REST is that should hit an action called `index` on the controller with the name of that resource.
- The `:id` in `get 'superheroes'/:id` is a wildcard that will match everything that comes after the path.
- A `post` request to the name of the resource should be creating one.
- A `patch` request will hit the `update` action.
- A `put` is similar to `patch`. We should have both of them.
- A `delete` request will hit the `destroy` action.
- The `resources :abilities, only: [:index]` is called a collection route because it has to do with the entire collection of abilities. conventionally, the `index` should show everything. The `[:show, :update, :create, :destroy]`, also called member routes, deal with particular abilities.
- From an API design standpoint, it is nice to nest your collection routes and not nest your member routes.

## Basic Controller Demo
- Here we are going to learn how to write controllers and see what the controllers are getting from the routers processing the HTTP request.
- If you type in `rails s` in the terminal, we can see the server is running at `http://localhost:3000`.
- We are going to test this code using Postman (extension for Chrome) because it gives us the ability to test our API.
- If we type in a `GET` request in Postman, `localhost:3000`, we will get back all html code.
- In order to hit the silly route, we need to do the following:
```ruby
Rails.application.routes.draw do
  # get 'superheroes', to: 'superheroes#index'
  # get 'superheroes/:id', to: 'superheroes#show'
  # post 'superheroes', to: 'superheroes#create'
  # patch 'superheroes/:id', to: 'superheroes#update'
  # put 'superheroes/:id', to: 'superheroes#update'
  # delete 'superheroes/:id', to: 'superheroes#destroy'

  # Can all be created with:
  # resources: superheroes, only: [:index, :show, :create, :update, :destroy]

  # Here we make a route that is going to hit a new controller that we are going to make.

  get 'silly', to: 'silly#fun'

  resources :superheroes do
    resources :abilities, only: [:index]
  end

  resources :abilities, only: [:show, :update, :create, :destroy]
end
```
- This will give us a routing error first because there is no silly controller. We need to make a `silly_controller.rb` file in `app/controllers`. Must be named with `silly` followed by `_controller.rb`
```ruby
class SillyController < ApplicationController
   def fun
     render text: "Hello"
    # render is coming from ApplicationController which comes from ApplicationController::Base
   end
end
```
If you send a request, `localhost:3000/silly`, you will just get back `Hello` in the body preview.
- As a reminder, a HTTP request consists of a HTTP method, query string potentially, request body potentially, and wildcards. If we have these wildcards in our routes, these are also kinds of parameters of the request, even though they are part of paths. We can access params in controllers using `params`:
```ruby
class SillyController < ApplicationController
   def fun
     render text: params
   end
end
# params (hash like object that is given to the controller by the router and contains 3 things)
# 1) Query string
# 2) Request body
# 3) URL Params/route params (wildcards)
```
When the route is matched, the router will take each of these pieces, parse them, and populate this params object with the key value pairs that match accordingly. The controller then can use these params as a hash.
- We can render in json (a data format that is a nice way of trafficking data across a network):
```ruby
class SillyController < ApplicationController
   def fun
     render json: params
   end
end
```
In postman, if you make the exact same `GET` request, `localhost:3000/silly` to the same exact route, you will get back `{"controller":"silly","action":"fun"}`, or in pretty form,
```
{
  "controller": "silly",
  "action": "fun"
}
```
- If we go back to Postman, and type in a request with a query string, `localhost:3000/silly?message=hi&fun=100`, we will get as a response:
```
{
  "message": "hi",
  "fun": "100",
  "controller": "silly",
  "action": "fun"
}
```
This works because the response is just the `params`, and in the `params`, there is the query string, and it is the router that did that.
- Inside of this controller action, you can use these `params` to do anything you wanted and you can access it like this:
```ruby
class SillyController < ApplicationController
   def fun
     render text: params[:message]
   end
end
```
We will get back just `hi` in the body in Postman. This `params` hash, we can treat as a normal hash, and because we saw that `params` had those key value pairs, we can access them.
- Now let's look at the request body. There is no way to put anything in the request body in a `GET` request so we need to make another route in order to show the `params` with a request body:
```ruby
Rails.application.routes.draw do
  get 'silly', to: 'silly#fun'
  post 'silly', to: 'silly#time'

  resources :superheroes do
    resources :abilities, only: [:index]
  end

  resources :abilities, only: [:show, :update, :create, :destroy]
end
```
and then make a time action (can be any name you want).
```ruby
class SillyController < ApplicationController
   def fun
     render json: params
   end

   def time
     render json: params
   end
end
```
Now we have the ability to put things into the request body. Go to Postman, change type of request from `GET` to `POST` and switch over to `Body`. Use `x-www-forum-urlencoded`. Type in the params section, `localhost:3000/silly` (getting rid of the query string for now). Give a key `age`, set value to `50`. Click send to send the request. We should get back:
```
{
  "age": "50",
  "controller" : "silly",
  "action": "time"
}
```
- Let's now write in the `POST` in postman a query string, `localhost:3000/silly?message=hi` and send. Now we see:
```
{
  "age": "50",
  "message": "hi",
  "controller" : "silly",
  "action": "time"
}
```
We see the message from the query string and the age from the form.
- Now let's try to use the URL params. Those would come from the wildcards. Let's make another route to take into consideration the wildcards.
```ruby
Rails.application.routes.draw do
  get 'silly', to: 'silly#fun'
  post 'silly', to: 'silly#time'
  post 'silly/:id', to: 'silly#super'

  resources :superheroes do
    resources :abilities, only: [:index]
  end

  resources :abilities, only: [:show, :update, :create, :destroy]
end
```
Now if we go over to super, we will write:
```ruby
class SillyController < ApplicationController
   def fun
     render json: params
   end

   def time
     render json: params
   end

   def super
     render json: params
   end
end
```
NOW, we can go back to Postman, type in `localhost:3000/silly/20`, remove the body (the key and value pair), and click send which will give back:
```
{
  "controller": "silly",
  "action": "super",
  "id": "20"
}
```
This `"id": "20"` came from the wildcard in the route. The URL had `20` in that place so params got a key of id and a value of 20. You can name the wildcard whatever you want but whatever you name the wildcard parameter is what it will be called in params in the controller.

## RESTful Controller Demo
- Let's take a look at a more conventional controller. Our `SuperheroesController` would look like this:
```ruby
class SuperheroesController < ApplicationController
  def index
    # Get all of the superheroes through the Superheroes model and render them
    render json: Superhero.all
  end
  def show
    # Find a particular superhero from the params[:id]
    superhero = Superhero.find_by(id: params[:id])

    render json: superhero
  end
  def create
    superhero = Superhero.new(superhero_params)
    if superhero.save
      render json: superhero
    else
      render json: superhero.errors.full_messages, status: :unprocessable_entity
    end
  end
  def update
    # Get a particular superhero and try to update them (change certain attributes of that object and save it).
    superhero = Superhero.find_by(id: params[:id])
    if superhero.update(superhero_params)
      # superhero_params is a nice conventional way of getting all of the params of the superhero we care about.
      render json: superhero
    else
      render json: superhero.errors.full_messages, status: :unprocessable_entity
      # We can specify the number here or use the special symbol :unprocessable_entity which rails would then do the job of putting in the number for you.
    end
  end
  def destroy
    superhero = Superhero.find_by(id: params[:id])
    if superhero.destroy
      render json: superhero
    else
      render json: "Can't destroy this superhero, too important"
    end
  end
  private
  def superhero_params
    # If we try to pass in params directly in the superhero.update() in update, it would update all even though there may be some attributes that you do not want the client to update. So we have to whitelist attributes within this method.  
    params.require(:superhero).permit(:name, :secret_identity, :power)
  end
end
```
If we now go to Postman and make a `GET` request `localhost:3000/superheroes`, we will get back,
```
[
  {
    "id": 2,
    "name": "Powdered toast man",
    "secret_identity": "Tom Toast",
    "power": 160,
    "created_at": "2015-11-16T19:02:00.787Z"
    "updated_at": "2015-11-16T19:02:00.787Z"
  },
  {
    "id": 3,
    "name": "Spiderman",
    "secret_identity": "Peter Parker",
    "power": 78,
    "created_at": "2015-11-16T19:30:13.701Z"
    "updated_at": "2015-11-16T19:30:13.701Z"
  }
]
```
- If we make a `GET` request with `localhost:3000/superheroes/2`, we will get back:
```
{
  "id": 2,
  "name": "Powdered toast man",
  "secret_identity": "Tom Toast",
  "power": 160,
  "created_at": "2015-11-16T19:02:00.787Z"
  "updated_at": "2015-11-16T19:02:00.787Z"
}
```
- Let's make a `PATCH` request, `localhost:3000/superheroes/2` and pass in some params (click on params next to the request bar in Postman). In the `Body`, use `x-www.form-urlencoded`. If we give key `power`, set value to `200`, we will get an error because our `superhero_params` requires a superhero. So instead, let's pass in the key, `superhero[power]` and the value `200` into our body in Postman. We will get back:
```
{
  "id": 2,
  "name": "Powdered toast man",
  "secret_identity": "Tom Toast",
  "power": 200,
  "created_at": "2015-11-16T19:02:00.787Z"
  "updated_at": "2015-05-26T23:36:55.019Z"
}
```
In our terminal we would see `Parameters: {"superhero" => {"power"=>"200"}, "id"="2"}`, that has a top level superhero. If we try to update an attribute that wasn't there, nothing will break nor update because of our permit in the `superhero_params`.
- We can run `bundle exec rake routes` in the terminal which shows the routes after it processes everything in the file.
- For the `POST` request, `localhost:3000/superheroes` (which will call the action create), we could pass into the body the key `superhero[power]` value `90`, key `superhero[name]` value `Wonder Woman`, and key `superhero[secret_identity]` value `Diana Prince`, and get back:
```
{
  "id": 4,
  "name": "Wonder Woman",
  "secret_identity": "Diana Prince",
  "power": 90,
  "created_at": "2016-05-26T23:42:52.614Z"
  "updated_at": "2016-05-26T23:42:52.614Z"
}
```
- If you forgot to pass in a parameter (like the secret_identity) that is needed when creating a new superhero, you would get back:
```
[
  "Secret identity can't be blank"
]
```
