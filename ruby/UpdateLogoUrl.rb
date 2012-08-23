require "rubygems"
require "json"
require "net/http"
require "open-uri"
require "sqlite3"

db = SQLite3::Database.new("git/myStream/assets/myStream.sqlite")

db.execute("SELECT * FROM canali") do |elem|
	_id = elem[0]
	name = elem[1]
	name = Iconv.conv("UTF8", "LATIN1", name).strip
	
	#puts "ID #{_id}"
	
	if elem[5] != nil and elem[5] != ""
		begin
			url = URI.parse(elem[5])
			req = Net::HTTP.new(url.host, url.port)
			req.open_timeout = 1000
			req.read_timeout = 1000
			res = req.request_head(url.path)
			
			case res
  				when Net::HTTPSuccess
					next if res.code == 200
				else
    				res.error!
				end
  				rescue Timeout::Error => e
    				puts "except #{e}"
    	rescue Exception => e2
    		puts "except #{e2}"
    	end
	end
	
	logo = ""
	begin
		result = {}
		re_name = name
		
		unless re_name.match(/tv/i) or re_name.match(/dance$/i)
			re_name += "+logo"
		else
			if re_name.match(/^tv\b/i)
				re_name = re_name.gsub(/tv\ /i, "")
				re_name += "+tv"
			end
		end
		re_name = re_name.gsub(" ", "+")
		re_name = re_name.gsub("-", "+")
		re_name = URI.escape(re_name)
		
		# cambiare ip per riprendere download
		google_url = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{re_name}&userip=192.168.1.86"
		puts re_name
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
		
		i = 0
		while i < result["responseData"]["results"].size
			#puts result["responseData"]["results"][i]
			#if result["responseData"]["results"][i]["width"].to_i > 900
			#	next
			#end
			
			tmp = result["responseData"]["results"][i]["unescapedUrl"]
			
			if tmp.match(/(jpg|jpeg|png|gif)/i)
				begin
					url2 = URI.parse(tmp)
					req2 = Net::HTTP.new(url2.host, url2.port)
					req2.open_timeout = 1000
					req2.read_timeout = 1000
					res2 = req2.request_head(url2.path)
					
					case res2
  						when Net::HTTPSuccess
  							if res.code == 200
								logo = tmp
								break
							end
  						else
    						res2.error!
  						end
  						rescue Timeout::Error => e
    						puts "except #{e}"
				rescue Exception => e2
					puts "except #{e2}"
				end
			end
			
			i += 1
		end
		
		unless logo.match(/^http/i)
			logo = ""
		end
		
	rescue Exception => e
		puts e
		puts result
		puts "#{name}"
		
		sleep 70
	end
	puts "--->>> #{logo}"
	#puts "ok"
	
	if (logo != "")
    	query = "UPDATE canali SET logo=\"#{logo}\" WHERE _id=#{_id};"
    	db.execute query
    end
    
    sleep 1
end

db.close
