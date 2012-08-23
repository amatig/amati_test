require "rubygems"
require "json"
require "net/http"
require "sqlite3"

url = "http://www.tvdream.mobi/app-andr/IT/channels.json"
resp = Net::HTTP.get_response(URI.parse(url))
data = resp.body

result = JSON.parse(data)

if result.has_key? "Error"
   raise "web service error"
end

db = SQLite3::Database.new("git/myStream/assets/myStream.sqlite")

countries = []
categories = []

for elem in result["channels"] do
	country = elem["country"].to_i
	category = elem["categories"][0].to_i
	best = (elem["best"]) ? 1 : 0
	
	if category != "" and country != ""
		if not countries.include? country
			countries << country
		end
		if not categories.include? category
			categories << category
		end
		
		name = elem["name"]
		name = Iconv.conv("UTF8", "LATIN1", name).strip	
		url = elem["url"]
		
		query = "SELECT * FROM \"canali\" WHERE titolo LIKE \"#{name}\";"
    	res = db.get_first_row query
    	
    	query = "SELECT * FROM \"canali\" WHERE url=\"#{url}\";"
    	res2 = db.get_first_row query
    	
    	if (not url.match(/tvdream/i)) and category != 0
    		unless res
    			unless res2
    				puts "insert #{name}"
    				
    				query = "INSERT INTO \"canali\" (titolo,categoria_id,nazione_id,url,blocco,consigliato) VALUES(\"#{name}\",#{category},#{country},\"#{url}\",0,#{best});"
    				db.execute query
    			end
    		else
    			if url != res[6]
    				puts "update url #{name}"
    				query = "UPDATE canali SET url=\"#{url}\" WHERE _id=#{res[0]};"
    				db.execute query
    			end
    		end
    	end
    end
end

puts "Nazioni nuove?"
puts countries.sort.length != 46
puts "Categorie nuove?"
puts categories.sort.length != 14

db.close
