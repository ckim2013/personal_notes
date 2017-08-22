# Rails Part 3

## Views Intro
- The user starts in the browser, makes a request (to `/users` for example), that is going to git the router, the router will go to an action in a controller, that controller will interact with the database to query up any data we need, and then send it back (via json or some other way) to the user. But now we will use that information about users that we have in the controller to generate a view which will be sent back to the user.
- Views will be located in `app/views`. To create a view, find the folder with the topic in hand (like `books`) and create an HTML file (`index.html.erb`).
  - We want this file to be in the view that is going to be rendered when we are inside the `index` **controller action**. `erb` means embedded ruby code which allows us to use ruby code in our HTML file.
- In our `books_controller.rb` we would have the following:
```ruby
def index
  @books = Book.all
  render :index # This is the view we want to render.
  # render 'index'
  # Can also be done with a string instead of symbol.
  # You actually don't need to specify render :index since rails will automatically try to find this template although it is good practice to be as explicit as possible in your actions.
end
```
This will tell rails that we want to render a view called `index` that is in the views folder, specifically in the `books` folder (because we are in the `books_controller.rb`). Rails will look for that `index` view for us.
- What our HTML `index.html.erb` will initially look like.
```html
<h1>All the books!</h1>
<%# ruby code that will not be printed %>
<%#= ruby code that we want to render %>
```
- Atom can get confused when commenting out ruby or html code. Don't forget to use `#`!
- Any instance variable defined in the instance method is going to be available to the index view that it then renders. We can use in our HTML erb tags which look like `<% %>` or `<%= %>`. We can write any ruby code we want in these tags! We can place ruby logic in `<% %>` and print code out using `<%= %>`.
- In atom, the keyboard shortcut for `<% %>` is `-` + `tab`. For `<%= %>`, it is `=` + `tab`.
- If we wanted to put the title of every book, we would have something like this:
```html
<h1>All the books!</h1>
<ul> <!-- Parent unordered list which will generate a bunch of li-->
  <% @books.each do |book| %>
    <li><%= book.title %></li>
  <% end %>
</ul>
```
- In rails, all of our controllers are inheriting from the `ApplicationController`, and our views are inheriting from the `ApplicationView` which is located in `app/views/layouts/application.html.erb`. In the body tag, in the application file, we see `yield`. Inside here, this is where any other template is going to be rendered. If we want something to appear on every single page, we can place it into this body in this specific file.
- Let's update the `show` action method in our `books_controller.rb`:
```ruby
def show
  @book = Book.find_by(id: params[:id])
  # render json: book
  # render :show
  if @book
    render :show
  else
    # return user back to index page
    # redirect_to '/books' # Instead of writing like the right, we can use a helper method as seen below (based on what we see in our routes)
    redirect_to books_url

    # You can also do the same as above below but it is bad practice!
    # unless @book
    #   render :show
    #   return
    # end
    # redirect_to books_url
  end
end
```
Let's also create a new `show.html.erb`:
```html
<h1><%= @book.title %></h1>
<h3>Author: <%= @book.author %></h3>
<h3>Year: <%= @book.year %></h3>
<h3>Category: <%= @book.category %></h3>
<p>
  <%= @book.description %>
</p>
```
- When we say `render`, rail will package up an html response and send it back to the user. When we say `redirect_to`, we are serving up a 302 level response back to the client, saying hey please make a new request to this url (`localhost3000/books`). The client (browser) will make another request to our server, hitting the index controller action. Thus, we do not care about instance variables etc since there is a new request to our site.
- We can only have one `render` or `redirect_to` in a method. You will get a double render error if you try!

## Rails View: Forms
- Let's add some new routes into our `routes.rb`:
```ruby
Rails.application.routes.draw do
  resources :books, only: [:index, :show, :new, :create]
end
```
- We need both `:new` and `:create` so the user can create new books into our database.
- Let's create a template for `new` and name it `new.html.erb`:
```html
<h1>Add book to library!</h1>
<!-- Action: url to which we want to send data  -->
<!-- Method: http method that we want to use -->
<form action="/books" method="post">
  <label for="title">Title</label>
  <input id="title" type="text" name="title">
  <!-- We are going to take whatever information is entered and give it a key of title as specified in name above for params -->
  <label for="author">Author</label>
  <input id="author" type="text" name="author">

  <label for="year">Year</label>
  <input id="year" type="text" name="year">

  <input type="submit" value="Add book to library">
</form>
```
- However, we want all of this data to be nested in a key rather than have a params with a bunch of keys. So we can do the following along with adding more functionality. Let's also change the action in the form:
```html
<h1>Add book to library!</h1>
<form action="<%= books_url %>" method="post">

  <label for="title">Title</label>
  <input id="title" type="text" name="book[title]">

  <br>

  <label for="author">Author</label>
  <input id="author" type="text" name="book[author]">

  <br>

  <label for="year">Year</label>
  <input id="year" type="date" name="book[year]">

  <br>

  <label for="category">Category</label>
  <select id="category" name="book[category]">
    <option disabled selected>-- Please Select --</option>
    <option value="Fiction">Fiction</option>
    <option value="Non-Fiction">Non-Fiction</option>
    <option value="Memoir">Memoir</option>
  </select>

  <br><br>

  <label for="description">Description</label>
  <textarea name="book[description]"></textarea>

  <input type="submit" value="Add book to library">
</form>
```
So far, we were nesting the user inputs under the key of book. So when we see this data come through in our controller, we will have all the attributes that the user wants to apply to a book nested under the key of book. We do this through the name attribute in the html tags themselves. Our last input is of type submit. It is going to add a button and because it is nested within the form, when we click on submit (which will be labeled as `"Add book to library"`), that is going to package up all the information that has been entered in this form and then make a post request to the specified url.
- Let's add a new and create action into our controller!
```ruby
def new
  render :new
end
def create
  @book = Book.new(book_params)
  # Normally, params would equal to { book: {title: 'HP', etc.}}. You don't want to pass params[:book] directly into new because of malicious people out there. Instead, let's pass in book_params.
  if @book.save #Don't use bang or else you'll get a 400 level exception error!
    # show user the book show page
    redirect_to books_url(@book) # Rails will automatically extract the id for us!
  else
    # show user the new book form
    render :new
    # We can use render :new here because create does not have a template.
  end
end
private
def book_params
  # This will permit attributes and return a hash that we can pass in directly when we try to create a new instance of book!
  params.require(:book).permit(:title, :author, :year, :category, :description)
end
```
