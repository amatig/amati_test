require "rubygems"
require "json"
require "net/http"
require "open-uri"
require "sqlite3"

url = "http://www.tvdream.mobi/app-andr/IT/channels.json"
resp = Net::HTTP.get_response(URI.parse(url))
data = resp.body

result = JSON.parse(data)

if result.has_key? "Error"
   raise "web service error"
end

db = SQLite3::Database.new("git/myStream/assets/myStream.sqlite")

_id = 0
for elem in result["channels"] do
	country = elem["country"].to_i
	category = elem["categories"][0].to_i
	
	if category != "" and country != ""
		name = elem["name"]
		
		row = db.get_first_row("SELECT logo FROM canali WHERE _id=#{_id} and titolo=\"#{name}\"")
		if row[0] and row[0] != ""
			_id += 1
			next
		end
		
		#puts _id
		
		logo = ""
		begin
			result = {}
			google_url = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{name} logo".gsub(" ", "%20")
			puts google_url
			
			open(google_url) do |f|
  				no = 1
  				f.each do |line|
  					#puts line
    				result = JSON.parse(line)
    				no += 1
    				break if no > 1
  				end
			end
			
			logo = result["responseData"]["results"][0]["unescapedUrl"]
			unless logo.match(/^http/)
				logo = ""
			end
		rescue Exception => e
			puts e
			puts result
			puts name
			
			sleep 70
		end
		#puts logo
		puts "ok"
		
    	query = "UPDATE canali SET logo=\"#{logo}\" WHERE _id=#{_id} and titolo=\"#{name}\";"
    	db.execute query
    	_id += 1
    	
    	sleep 1
    end
end

db.close
