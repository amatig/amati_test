require "rubygems"  # not necessary for Ruby 1.9
require "mongo"

class Prova

  def initialize
    @nome = "giovanni"
  end
  
end

#conn = Mongo::Connection.new
#conn.database_names.each { |name| puts name }

db = Mongo::Connection.new.db("mydb")
coll = db.collection("prova")
doc = {"name" => "MongoDB", "type" => "database", "count" => 1,
  "info" => {"x" => 204, "y" => '102'}}
doc = {"nome" => "giovanni"}
coll.insert(doc)

coll.save(doc)

coll.find().each { |row| puts row.inspect }
