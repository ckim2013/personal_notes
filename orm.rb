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
