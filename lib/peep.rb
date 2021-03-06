require 'pg'

class Peep
  attr_reader :id, :content, :timestamp

  def initialize(id, content, timestamp)
    @id = id
    @content = content
    @timestamp = timestamp
  end

  def self.all
    result = connection_to_database.exec("SELECT * FROM feed ORDER BY
      timestamp DESC;")
    result.map do |peep|
      Peep.new(peep['id'], peep['peep'], peep['timestamp'])
    end
  end

  def self.create(content)
    result = connection_to_database.exec("INSERT INTO feed (peep) VALUES
    ('#{content}') RETURNING id, peep, timestamp;")
    Peep.new(result[0]['id'], result[0]['peep'], result[0]['timestamp'])
  end

  def self.connection_to_database
    ENV['RACK_ENV'] == 'test' ? (db = 'chitter_test') : (db = 'chitter')
    PG.connect(dbname: db)
  end
end
