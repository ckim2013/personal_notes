# Rails

## Intro
- To get started, type in `rails new <project_name> -d postgresql` into the terminal.
- It will use `sqlite3` has a default database (we don't want this!), which is why we want to specify that we want to use `postgresql` in our terminal command.
- A new folder will be created and filled it with files.
  - In the `Gemfile`, we should add a gem `gem 'pry-rails'` to use pry in the rails console. Bundle install after doing this.
  - The `app` folder has most of work when we work on the ruby code. Holds `controllers`, `models`, `views`, etc.
    - `models`: A class which represents a table from the database.
    - `controllers`: Handles the logic of what to do when a request comes in and it will access the models and views when building a response (ex. html view).
    - `views`: A template which is going to be filled in with content from `models` layer. Content from `models` layer will be provided by a controller in our `controllers` folder.
  -  `config` is going to hold configurations.
    - `database.yml`: Specifies which database and database name we are connecting to.
    - `routes.rb`: Defines what HTTP routes our program makes available. Also decides which controllers to create and trigger actions on when requests come on.
  - `db`: Holds the `seeds.rb` file.
    - `seeds.rb`: Populates our database (we use this for test data).
  - `lib`: Holds any classes that we might have made internally that we are going to use in our rails project.
  - `test`: Once we write tests for our rails, they will end up in here.
  - `vendors`: Where we place javascript files and other external libraries that we did not make.

## Migrations
- A paper trail, record of how the database got to the current state.
- To create a migration, type into terminal, `rails generate migration <TableNameWeWantToCreate>`
- This new file will be in the `migrate` folder in the `db` folder. Example below. We can also add columns to the table:
```ruby
class CreateCatTable < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.string :name, null: false
      t.timestamps # Two columns in practice. Put in all tables we create.
    end
  end
end
```
- In terminal, type in `rake db:create` if you get an error trying to type in `rake db:migrate`. The `create` will create the database which `migrate` will then work.
- `migrate` will then create a `schema.rb` file in `migrate` which will just update with more tables.
- Let's create another table and add to the columns using first the terminal command, `rails g migration CreateToys`. A new file will be created in the `migrate` folder.
```ruby
class CreateToys < ActiveRecord::Migration
  def change
    create_table :toys do |t|
      t.string :name, null: false
      t.integer :cat_id, null: false #foreign key
      t.timestamps
  end
end
```
- If we ever make a mistake, rerunning `rake db:migrate` will not work (or do anything really). Instead, type in `rake db:rollback` which just deletes the entire table. **BE WARNED** this can cause an error depending on the circumstances.
- If we are in development mode and we are rolling back one migration (due to mistake on local machine), that should be fine. If during production (pushed to GitHub, Heroku, etc.), we should never rollback and edit a migration. Instead, just create a new migration where it would add the missing data (column) into the table we want.
- In order to edit a table, do the following example. Type into terminal, `rails g migration AddColorToCats`. This will not auto populate like before because rails can't infer what we are trying to do based on the name we typed in.
```ruby
class AddColorToCats < ActiveRecord::Migration
  def change
    add_column :cats, :color, :string
  end
end
```
- If you then type in `rake db:migrate`, the schema will update with this new column for the cats table.
- You shouldn't edit migrations that you already ran.

## Models
- Here we are going to learn how to use rails models to interact with the contents of our tables by making models.
- In the `app/models` folder, make the file `cat.rb` which is a model that will interact with the cats table.
```ruby
# cat.rb
class Cat < ActiveRecord::Base # This creates a cat model and now we have the ability to read, write, and search cats.
end
```
- We interact with this class using the rails console. We can access this in terminal by typing `rails console` or `rails c`.
- In the rails console (pry), we can create an instance using `c = Cat.new`.
- We can set the name of this cat by typing `c.name = "Sarah"`.
- We can insert this cat into the database by saying `c.save`.
- When we type in `sarah = Cat.first`, it will read from the cats table the first row, and `SELECT "cats".* FROM "cats" ORDER BY "cats".id ASC LIMIT 1` which creates and instantiates an instance of this `Cat` class and sets the properties of this cat instance to whatever that was stored in the column values.
- We can create another cat by typing `jeff = Cat.new(name: "Jeff", color: "green")`.
- We can check all of the cats in the database by typing `cats.all` which will give us an array of cat instances.
- We can see the last inserted by typing `cats.last`.
- We can get rid of `jeff` by typing `jeff.last` and then `jeff.destroy`.
- We can find a cat by typing `Cat.find(1)` where 1 `i` the id.
- We can use `Cat.create(name: "Jeff", color: "orange")` to recreate Jeff, although the `id` will be `3` now since you added a cat before. **ASK TA ABOUT THIS AND IF THIS CAN MESS THINGS UP**.

## Basic Associations (belongs_to, has_many)
- Let's say we also have a `house.rb` file along with the cat and toy files. The cats will also have a house_id column.
- This is what our `seeds.rb` should look like.
```ruby
ranch_house = House.create(house_type: "Ranch House")
beach_house = House.create(house_type: "Beach House")
sarah = Cat.create(name: "Sarah", color: "black", house_id: ranch_house.id)
jeff = Cat.create(name: "Jeff", color: "orange", house_id: beach_house.id)
Toy.create(name: "Yarn", cat_id: sarah.id)
Toy.create(name: "Squeaker", cat_id: sarah.id)
Toy.create(name: "Feather", cat_id: jeff.id)
Toy.create(name: "Ball", cat_id: jeff.id)
```
- Let's add a method into the `Cat` class.
```ruby
class Cat < ActiveRecord::Base
  def house
    House.find(self.house_id)
  end
end
```
- In the rails console, we can write `jeff = Cat.last` and then `jeff.house` which invokes the instance method which points to the right house that the cat belongs to. This same process can be done with a macro as seen below.
```ruby
class Cat < ActiveRecord::Base
  belongs_to :house, { # Don't need curly braces! But shows that this is a hash. :house is the name of the method.
    primary_key: :id,
    foreign_key: :house_id,
    class_name: 'House'
  }
end
```
- We can add a method to our `House` class which will give back the cats that live in this house.
```ruby
class House < ActiveRecord::Base
  def cats
    Cat.where(house_id: self.id)
  end
end
```
- Again, we can do the same function as above using the `has_many` macro.
```ruby
class House < ActiveRecord::Base
  has_many :cats,
    primary_key: :id,
    foreign_key: :house_id,
    class_name: 'Cat'
end
```
- In an association between two tables, there will only be one foreign key and one primary key. The one that has the foreign key is the one that belongs to the other. The one that has a foreign key.
- Writing `has_many` also creates a setter ability.

## More Associations (has_many, through:...)
- Imagine that we now have a `toy.rb` file with the following code.
```ruby
class Toy < ActiveRecord::Base
  belongs_to :cat,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: 'Cat'
end
```
- Let's also imagine that the `cat.rb` is updated to the one below.
```ruby
class Cat < ActiveRecord::Base
  belongs_to :house,
    primary_key: :id,
    foreign_key: :house_id,
    class_name: 'House'

  has_many :toys,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: 'Toy'
end
```
- We want an association which will allow us to go across two associations. For example, we want to get all of the toys for all of the cats that live in this house, OR, I want to get directly to the house that this toy lives in through cat.
- Let's try to implement this below:
```ruby
class House < ActiveRecord::Base
  has_many :cats,
    primary_key: :id,
    foreign_key: :house_id,
    class_name: 'Cat'

  def toys # Gives all of the toys for all of the cats that live in this house
    toys = []
    house.cats.each do |cat|
      toys += cat.toys
    end
    toys
  end
end
```
- But instead of writing this method ourselves, let's write `has_many`.
```ruby
class House < ActiveRecord::Base
  has_many :cats,
    primary_key: :id,
    foreign_key: :house_id,
    class_name: 'Cat'

  has_many :toys,
    through: :cats, # Name of the association IN THIS CLASS
    source: :toys # Name of an association in the Cat class and the return value should be our target
end
```
- `through` is only used with `has_many` and `hash_one`.
- The code below will work for `toy.rb`.
```ruby
class Toy < ActiveRecord::Base
  belongs_to :cat,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: 'Cat'

  has_one :house,
    through: :cat,
    source: :house

  # The above is equivalent to the query below
  <<-SQL
  SELECT *
  FROM cats
  JOIN houses ON cats.house_id = houses.id
  WHERE id = #{self.cat_id}
  SQL
  .first
end
```

## Validations
- We never want a database error to be thrown. To prevent this, we will add a layer of defense (validation) at the model layer. We do this like below which will return `false` if you add an attribute that cannot be `NULL`.
```ruby
class Cat < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :color, presence: true
  validate :no_green_cats
  # You can write a customized validation
  def no_green_cats
    if self.color == "green"
      self.errors[:color] << "can't be green"
    end
  end

  belongs_to :house,
    primary_key: :id,
    foreign_key: :house_id,
    class_name: 'House'

  has_many :toys,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: 'Toy'
end
```
- In terminal, we can check if a variable can be added to the database by typing `c.valid?`.
- `uniqueness` makes it so that this column must have some value and that value must not be the same as any other name in the table.
- A good trick on terminal is to type `Cat.all.pluck(:name)` which will return an array of just names, not even instances.
- Doing a `valid?` check would return `false` if you tried to add a cat with an identical name as a cat in the database using `save`. To check why it is not valid, type in `c.errors`. To make it even more clear, type in `c.errors.full_messages`.
- If something is not valid (with model level validations) but you use `save!` in terminal, an exception would be raised.

## Indices
- Imagine we have a seed file that looks like this.
```ruby
ranch_house = House.create(house_type: "Ranch House")
beach_house = House.create(house_type: "Beach House")
sarah = Cat.create(name: "Sarah", color: "black", house_id: ranch_house.id)
jeff = Cat.create(name: "Jeff", color: "orange", house_id: beach_house.id)
Toy.create(name: "Yarn", cat_id: sarah.id)
Toy.create(name: "Squeaker", cat_id: sarah.id)
Toy.create(name: "Feather", cat_id: jeff.id)
Toy.create(name: "Ball", cat_id: jeff.id)
100000.times do
  Cat.create!(name: Faker::Name.first_name, color: :orange)
```
- We can use indices to speed up lookup in our ActiveRecord tables. Now we have this new `cat.rb`.
```ruby
class Cat < ActiveRecord::Base
  validates :name, presence: true
  validates :color, presence: true
  validate :no_green_cats
  # You can write a customized validation
  def no_green_cats
    if self.color == "green"
      self.errors[:color] << "can't be green"
    end
  end

  def self.how_long_to_find_sarahs_in_ms
    start = Time.now
    Cat.where(name: 'Sarah').to_a
    (Time.now - start) * 1000
  end

  belongs_to :house,
    primary_key: :id,
    foreign_key: :house_id,
    class_name: 'House'

  has_many :toys,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: 'Toy'
end
```
- The benchmark test is fast but not fast enough. We can solve these using indices.
- Index is a tree (data structure) which is stored in our database but does not require us to make a table for. With a sorted tree, it will make the lookup time from linear to logarithmic (making it fast!).
- To create an index, we run a migration that looks like this.
```ruby
  class AddIndexToCats < ActiveRecord::Migration
    def change
      add_index :cats, :name # This will make an index for name
      # First argument is name of the table and the second is the name of the column we are adding index for. You can index multiple columns together.
    end
  end
```
- We don't add indices for all columns because they take up space. We index columns that we are going to use frequently for lookup, including **foreign keys**!
- Once we `rake db:migrate`, we can test the benchmark again and it is significantly faster now to find all sarahs.
- If you want to do a database level of validation for uniqueness, you would do that with an index.
