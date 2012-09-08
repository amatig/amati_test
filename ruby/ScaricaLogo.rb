require "rubygems"
require "json"
require "net/http"
require "sqlite3"

db = SQLite3::Database.new("git/myStream/assets/myStream.sqlite")

db.execute("SELECT * FROM canali") do |elem|
	_id = elem[0]
	name = elem[1].gsub("/", "-")
	name = Iconv.conv("UTF8", "LATIN1", name).strip
	
	unless FileTest::directory?("images_temp")
		Dir::mkdir("images_temp")
	end
	unless FileTest::directory?("images")
		Dir::mkdir("images")
	end
	filename = "images_temp/#{_id}"
	
	if (not FileTest.exists?(filename)) and elem[5] != nil and elem[5] != ""
		begin
			Thread.new do
				puts "#{_id} #{name}"
				url = elem[5]
				resp = Net::HTTP.get_response(URI.parse(url))
				data = resp.body
				
				File.open(filename, 'w') do |f2|  
  					# use "\n" for two lines of text  
  					f2.puts data 
				end
				
				%x[convert -resize 100x100 -quality 75 -format PNG images_temp/#{_id} images/#{_id}.png]
			end
    	rescue Exception => e2
    		puts "except #{e2}"
    	end
	end
	
end

db.close
