# SQL

## Introduction
- Supported by all major commercial database systems.
- SQL can be used in a database systems interactively through a GUI or prompt, or embedded in programs.
- SQL is declarative, based on relational algebra.
  - Query optimizer: Takes a query written in SQL and finds out the best, and fastest way to execute that on the database.
- Data Definition Language (DDL)
  - Includes commands to create tables, drop tables, etc.
- Data Manipulation Language (DML)
  - Query and modify the database. Includes `SELECT`, `INSERT`, `DELETE`, `UPDATE`, etc.
- Relational query languages are compositional: When you run a query over relations, you get a relation as a result.

## Programming Paradigms
- Programming paradigms: Ways to classify programming languages according to their style!
- Two opposite types in Ruby: imperative and declarative.
  - Imperative Programming
    - The original style of high-level languages which feeds step-by-step instructions for the computer to execute. Example below:
    ```ruby
    def imperative_odds?(array)
      idx = 0
      odds = []
      while (idx < array.length)
        if array[idx].odd?
          odds << array[idx]
        end
        i += 1
      end
      odds
    end
    ```
  - Declarative Programming
    - Describes what you want to achieve, without going into to much detail about how you're going to do it. Example below:
    ```ruby
    def declarative_odds?(array)
      odds = array.select { |el| el.odd? }
    end
    ```

## Databases
- Relational databases (RDBMS, relational database management systems) provide a means of organizing data and their relationships, persisting the data, and querying that data.
- RDBMS organize data in tables like the one below.

| id            | name          | age  |
| ------------- | ------------- | ----- |
|1|Chris|22|
|2|Thai|24|
|3|Jesse|54|
|4|Paolo|48|
|5|Alvin|33|
|6|Katrina|98|
- Each row = single entity in the table. Each column houses additional piece of data associated with each instance of the resource. Every row in a database has a primary key (`id`) which will be the unique identifier in that table row.

## Database Schemas
- It's a description of the organization of your database into tables and columns. What data does my application need to function?
- We have to first decide on three things:
  - The tables we will have
  - The columns each of those tables will have
  - The data type of each of those columns
- Schemas are mutable so decisions upfront are not set in stone.
- SQL is statically typed vs Ruby which is dynamically typed (there is no need to specify in method parameters or variables the class (type) of the data stored in it).
- Most common datatypes in columns:
  - `BOOLEAN`
  -  `INT`
  - `FLOAT` (stores "floating point" numbers)
  - `VARCHAR(255)` (a string with a length limit of 255 characters)
  - `TEXT` (a string of unlimited length)
  - `DATE`
  - `DATETIME`
  - `TIME`
  - `BLOB` (non-textual, wildcard, binary data; e.g. an image)

## Modeling Relationships
- We can model relationships between entries in separate tables through foreign keys. A foreign key is a value in a database table whose responsibility is to point to a row in a different table. An example of this can be users and their blog posts. Make another table and have their foreign keys, `user_id` in another column. The foreign key in one table will reference the primary key in another table. We usually call the column that houses the foreign key.

## Structured Query Language (SQL)
- SQL is a domain-specific language that is designed to query data out of relational databases. Example below where we find crazy cat people:
```SQL
SELECT
  name, age, has_cats
FROM
  tenants
WHERE
  (has_cats = true AND age > 50)
```
- SQL is broken down into clauses (`SELECT`, `FROM`, `WHERE`).
  - `SELECT`: Takes a list of comma-separated column names (only these columns of data will be retrieved).
  - `FROM`: Takes a table name to query.
  - `WHERE`: Takes a list of conditions separated by `AND` or `OR`. Only rows matching these conditions are returned.
    - Supports standard comparison and equality operators (`<`, `>`, `>=`, `<=`, `=`, `!=`) and boolean operators (`AND`, `OR`, `NOT`).
    - You do not always need a where! Sometimes, problems can be solved using `HAVING` after `GROUP BY`
  - Four main data manipulation operations for SQL
    - `SELECT`: Retrieve values from one or more rows.
    - `INSERT`: Insert a row into a table.
    - `UPDATE`: Update values in one or more existing rows.
    - `DELETE`: Delete one or more rows.
  - Below are brief descriptions of each of the operators syntactical signatures and a couple simple examples of their use:
    - `SELECT`
      - Structure:
      ```SQL
      SELECT
        one or more columns (or all columns with *)
      FROM
        one (or more tables, joined with JOIN)
      WHERE
        one (or more conditions, joined with AND/OR);
      ```
      - Examples (separted by `;`):
      ```SQL  
      SELECT
        *
      FROM
        users
      WHERE
        name = 'Ned';
      SELECT
        account_number, account_type
      FROM
        accounts
      WHERE
        (customer_id = 5 AND account_type = 'checking');
      ```
    - `INSERT`
      - Structure
      ```SQL
      INSERT INTO
        table name (column names)
      VALUES
        (values);
      ```
      - Examples:
      ```SQL
      INSERT INTO
        users (name, age, height_in_inches)
      VALUES
        ('Santa Clause', 876, 34);
      INSERT INTO
        accounts (account_number, customer_id, account_type)
      VALUES
        (12345, 76, 'savings');
      ```
    - `UPDATE`
      - Structure
      ```SQL
      UPDATE
        table_name
      SET
        col_name1 = value1,
        col_name2 = value2
      WHERE
        conditions
      ```
      - Examples:
      ```SQL
      UPDATE
        users
      SET
        name = 'Eddard Stark', house = 'Winterfell'
      WHERE
        name = 'Ned Stark';
      UPDATE
        accounts
      SET
        balance = 30
      WHERE
        id = 6;
      ```
    - `DELETE`
      - Structure
      ```SQL
      DELETE FROM
        table_name
      WHERE
        conditions
      ```
    - Examples:
      ```SQL
      DELETE FROM
        users
      WHERE
        (name = 'Eddard Stark' AND house = 'Winterfell');
      DELETE FROM
        accounts
      WHERE
        customer_id = 999;
      ```

## Schema Definitions
- You need to define database schema before quering.
- Three operators to manipulate a database schema:
  - `CREATE TABLE`
  - `ALTER TABLE`
  - `DROP TABLE`
- Example of creating a users table
  ```SQL
  CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    house VARCHAR(255),
    favorite_food VARCHAR(20)
  );
  ```
- `CREATE TABLE` specifies name of the table and then in parentheses, the list of column names along with their data types.  

## Querying across multiple tables (JOIN)
- How do we query across tables at once?
- `JOIN` joins together two tables => temporary combined table that you can query from just like any other.
- `JOIN` clauses include `ON` statement. Here, we specify how exactly those two tables relate to each other. Here, we need foreign keys. Example below (query that returns title of all blog posts written by each user):
```SQL
SELECT
  user.name, posts.title
FROM
  posts
JOIN
  users ON posts.user_id = users.id
```
- Above returns one row per post, with user's name appearing next to the title of the post they authorized. We can associate user data to posts without adding columns that would duplicate data from other tables in the database and other rows in the `post` table. Just `JOIN` as needed. So we joined two different tables using a foreign key stored in a single column.
- Other variations of `JOIN` exist.
  - Self joins where we join a table to itself.
  - Joins that use multiple columns to specify the `ON` condition.
- In an example of users liking posts for a website (many-to-many-relationship), we can use a join table that contains a foreign key for each table, allowing us to represent each like with a row linking a user to a post. Then we need two joins to associate users and like posts like shown below:
```SQL
SELECT
  user.name, posts.title
FROM
  posts
JOIN
  likes ON posts.id = likes.post_id
JOIN
  users ON likes.user_id = users.id
```

## [A Visual Explanation of Joins](https://blog.codinghorror.com/a-visual-explanation-of-sql-joins/)

## Self Joins
- Self join: an instance of a table joining with itself. Example below:
##### Employee Table

| id             | first_name     | last_name      | manager_id     |
| :------------- | :------------- | :------------- | :------------- |
| 1              | Kush           | Patel          | NULL           |
| 2              | Jeff           | Fiddler        | 1              |
| 3              | Quinn          | Leong          | 2              |
| 4              | Shamayel       | Daoud          | 2              |
| 5              | Robert         | Koeze          | 4              |
| 6              | Munyo          | Frey           | 3              |
| 7              | Kelly          | Chung          | 4              |

```SQL
SELECT
  team_member.first_name, team_member.last_name, manager.first_name, manager.last_name
FROM
  employee AS team_member
JOIN
  employee AS manager ON manager.id = team_member.manager_id
```
| team_member.first_name | team_member.last_name | manager.first_name | manager.last_name |
| :--------------------- | :-------------------- | :----------------- | :---------------- |
| Jeff                   | Fiddler               | Kush               | Patel             |
| Quinn                  | Leong                 | Jeff               | Fiddler           |
| Shamayel               | Daoud                 | Jeff               | Fiddler           |
| Robert                 | Koeze                 | Shamayel           | Daoud             |
| Munyo                  | Frey                  | Quinn              | Leong             |
| Kelly                  | Chung                 | Shamayel           | Daoud             |
- We need aliases (nicknames for tables) when dealing with one table in a self join. Aliases are needed because the query processor needs to make a distinction between the duplicates of the same table to JOIN them. Above SQL can be rewritten as below because `AS` is not necessary to alias tables or columns:
```SQL
SELECT
  team_member.first_name, team_member.last_name, manager.first_name, manager.last_name
FROM
  employee team_member
JOIN
  employee manager ON manager.id = team_member.manager_id
```

## Formatting SQL Code
- Name SQL tables **snake_case** and **pluralized**.
- Always have a column named `id` to use as primary keys.
- Complex `WHERE` clauses are parenthesized and indented two spaces on the following line.

## [Subqueries](https://sqlbolt.com/topic/subqueries)

## NULL and Ternary Logic in SQL
- SQL uses ternary logic where a conditional statement can evaluate to `TRUE`, `FALSE`, or `NULL` (unknown) where `NULL` is still falsy.
- `NULL` was derived to represent an unknown value. So `NULL == NUL` will be false.
- Always use `IS NULL` or `IS NOT NULL` in lieu of `==` or `!=` comparisons.

## [CASE](http://www.postgresqltutorial.com/postgresql-case/)

## [COALESCE](http://www.postgresqltutorial.com/postgresql-coalesce/)

## Example of creating a table
- We will create two tables of plays and playwrights:
  ```SQL
  -- import_db.sql
  CREATE TABLE plays (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    year INTEGER NOT NULL,
    playwright_id INTEGER NOT NULL

    FOREIGN KEY (playwright_id) REFERENCES playwrights(id)
  );

  CREATE TABLE playwrights (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    birth_year INTEGER
  );

  -- We should add data to the playwrights first due to the foreign key in plays. We cannot create an instance of play until we have a reference which in this is playwrights
  INSERT INTO
    playwrights (name, birth_year)
  VALUES
    ('Arthur Miller', 1915),
    ('Eugene O'' Neill', 1888); -- Have to use '' instead of escape key as seen in ruby

  INSERT INTO
    plays (title, year, playwright_id)
  VALUES
    ('All My Sons', 1947, (SELECT id FROM playwrights WHERE name = 'Arthur Miller')),
    ('Long Days''s Journey Into Night', 1956, (SELECT id FROM playwrights WHERE name = 'Eugene O'' Neill'));
  ```
- Anytime we want to add a row, the title column is not optional, we need to have that information! That is why we add `NOT NULL`. This is implicit for `PRIMARY KEY`.
- After writing the above, we would go into terminal and type in `cat import_db.sql | sqlite3 plays.db`.
- Above is saying that we want to concatenate (`cat`) the output for the import_db.sql file and we want to throw it in `sqlite3`, specifically in a file called `plays.db`. We would now have a file that was created in the same working folder as in the `import_db.sql`.
- We can then write in the terminal `sqlite3 plays.db`. Some useful commands:
  - `.tables`: Show us what tables we have in the database.
  - `.schema`: Representation of the structure of our database (no values but how our data is configured).
- We can add to our database via below in terminal:
  - `INSERT INTO playwrights (name, birth_year) VALUE ('Tennessee Williams', 1911);`
- We can extract this database into pry via below (done in pry):
  - `require "sqlite3"` which loads the gem.
  - `plays_db = SQLite3::Database.new('./plays.db')` which assigns an instance of the database to a variable.
  - `plays_db.execute("SELECT * FROM plays")` Takes in a string that is a SQL query and will run that against the database. This will return an array.
  - `plays_db.execute("INSERT INTO plays (title, year, playwright_id) VALUE ('The Glass Menagerie', 1944, 3)")`

## SQLite ORM (Object Relational Mapping)
- How we might implement an ORM for the plays database:
```ruby
require 'sqlite3'
require 'singleton'
# Makes sure that we only ever have one instance of our database
class PlayDBConnection < SQLite3::Database
  include Singleton
  def initialize
    super('plays.db')
    self.type_translation = true
    # Makes sure that all the data we get back is the same datatype as
    # the data we passed into the database.
    self.results_as_hash = true
    # We want the data to come back as a hash. Every column is a key that
    # points to a value stored in the column.
    #
  end
end
class Play
  attr_accessor :title, :year, :playwright_id
  def self.all
    # Shows us every entrance we have in our plays database.
    # data will hold an array of hashes.
    data = PlayDBConnection.instance.execute("SELECT * FROM plays")
    # ORM aspect below
    data.map { |datum| Play.new(datum) }
  end
  def initialize(options)
    # Creates a new instance of the play class.
    @id = options['id'] # Either be defined or set to nil
    @title = options['title']
    @year = options['year']
    @playwright_id = options['playwright_id']
  end
  def create
    # Saves the instance to the database.
    raise "#{self} is already in the database" if @id
    # Heardoc allows us embed a bunch of code that will just be read in as a string
    PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id)
      INSERT INTO
        plays (title, year, playwright_id)
      VALUES
        (?, ?, ?) -- Pulls values from the instance variables next to <<-SQL.
    SQL
    # ? protects us from SQL injection attacks (malicious users)
    # playwright_id == "3, DROP TABLE plays"
    @id = PlayDBConnection.instance.last_insert_row_id
  end
  def update
    # When we want to update information in our table.
    raise "#{self} not in database" unless @id
    PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id, @id)
      UPDATE
        plays
      SET
        title = ?, year = ?, playwright_id = ? -- Don't want to change ID here.
      WHERE
        id = ?
    SQL
  end
end
```
