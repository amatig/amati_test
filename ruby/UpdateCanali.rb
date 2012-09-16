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

countries = []
categories = []

temp = []

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
		
		temp.push(url)
		
		query = "SELECT * FROM \"canali\" WHERE titolo LIKE \"#{name}\";"
    	check_name = db.get_first_row query
    	
    	query = "SELECT * FROM \"canali\" WHERE url=\"#{url}\";"
    	check_url = db.get_first_row query
    	
    	if (not url.match(/tvdream/i)) and !temp.include?(url) and category != 0
    		unless check_url
    			unless check_name
    				puts "new channel #{name}"
    				query = "INSERT INTO \"canali\" (titolo,categoria_id,nazione_id,url,blocco,consigliato) VALUES(\"#{name}\",#{category},#{country},\"#{url}\",0,#{best});"
    				db.execute query
    			else
    				puts "update url #{name}"
    				query = "UPDATE canali SET url=\"#{url}\" WHERE _id=#{check_name[0]};"
    				b.execute query
    			end
    		else
    			puts "update name #{name}"
    			query = "UPDATE canali SET titolo=\"#{name}\" WHERE _id=#{check_url[0]};"
    			db.execute query
    		end
    	else
    		#if category == 0
    		#	puts "cat 0 -->> #{name}"
    		#end
    		#if url.match(/tvdream/i)
    		#	puts "tvdream -->> #{name}"
    		#end
    	end
    end
end

db.execute("SELECT * FROM canali") do |elem|
	if !temp.include?(elem[6])
		puts "to remove #{elem[0]} #{elem[1]}"
	end
end

puts "Nazioni nuove?"
puts countries.sort.length != 46
puts "Categorie nuove?"
puts categories.sort.length != 14

db.close
