require "rubygems"
require "json"
require "net/http"
require "sqlite3"

url = "http://www.tvdream.mobi/app-andr/IT/channels.json"
resp = Net::HTTP.get_response(URI.parse(url))
data = resp.body
data = Iconv.conv("UTF8", "LATIN1", data).gsub("\n","").gsub("\r","")

result = JSON.parse(data)

if result.has_key? "Error"
   raise "web service error"
end

db = SQLite3::Database.new("git/myStream/assets/myStream.sqlite")

names = {}

for elem in result["channels"] do
	name = elem["name"]
	name = Iconv.conv("UTF8", "LATIN1", name).strip	
	names[name] = true
	#puts name
end

db.execute("SELECT * FROM canali") do |elem|
	name = elem[1]
	name = Iconv.conv("UTF8", "LATIN1", name).strip
	
	unless (names[name])
		puts "remove #{name}"
	end
end
    	
db.close
