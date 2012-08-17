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

db.execute "DROP TABLE IF EXISTS \"android_metadata\";"
db.execute "CREATE TABLE \"android_metadata\" (\"locale\" TEXT DEFAULT \"en_US\");"
db.execute "INSERT INTO \"android_metadata\" VALUES(\"en_US\");"
db.execute "DROP TABLE IF EXISTS \"canali\";"
db.execute "CREATE TABLE \"canali\" (\"_id\" INTEGER PRIMARY KEY  NOT NULL ,\"titolo\" VARCHAR,\"categoria_id\" INTEGER,\"nazione_id\" INTEGER,\"descrizione\" VARCHAR,\"logo\" VARCHAR,\"url\" VARCHAR,\"blocco\" VARCHAR,\"consigliato\" INTEGER);"
db.execute "DROP TABLE IF EXISTS \"categorie\";"
db.execute "CREATE TABLE \"categorie\" (\"_id\" INTEGER PRIMARY KEY  NOT NULL ,\"categoria\" VARCHAR,\"categoria_en\" VARCHAR,\"categoria_cn\" VARCHAR);"
db.execute "DROP TABLE IF EXISTS \"nazioni\";"
db.execute "CREATE TABLE \"nazioni\" (\"_id\" INTEGER PRIMARY KEY  NOT NULL ,\"nazione\" VARCHAR,\"nazione_en\" VARCHAR,\"nazione_cn\" VARCHAR);"

countries = []
categories = []

_id = 0
for elem in result["channels"] do
	#p elem
	#if elem["country"] == "45"
	#	puts elem["description"] + " " + elem["country"]
	#end
	
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
		url = elem["url"]
		
    	query = "INSERT INTO \"canali\" VALUES(#{_id},\"#{name}\",#{category},#{country},NULL,NULL,\"#{url}\",0,#{best});"
    	db.execute query
    	_id += 1
    end
end

puts "0..45"
p countries.sort
puts "0..13"
p categories.sort

map_countries = {
	"0"  => ["Albania","Albania","阿尔巴尼亚"],
	"1"  => ["Argentina","Argentine","阿根廷"],
	"2"  => ["Belgio","Belgium","比利时"],
	"3"  => ["Brasile","Brazil","巴西"],
	"4"  => ["Bulgaria","Bulgaria","保加利亚"],
	"5"  => ["Canada","Canada","加拿大"],
	"6"  => ["Cina","China","中国"],
	"7"  => ["Corea","Korea","舞蹈病"],
	"8"  => ["Croazia","Croatia","克罗地亚"],
	"9"  => ["Egitto","Egypt","埃及"],
	"10" => ["Finlandia","Finland","芬兰"],
	"11" => ["Francia","France","法国"],
	"12" => ["Georgia","Georgia","格鲁吉亚"],
	"13" => ["Germania","Germany","德国"],
	"14" => ["Giappone","Japan","日本"],
	"15" => ["Grecia","Greece","希腊"],
	"16" => ["India","India","印度"],
	"17" => ["Iran","Iran","伊朗"],
	"18" => ["Iraq","Iraq","伊拉克"],
	"19" => ["Irlanda","Ireland","爱尔兰"],
	"20" => ["Israele","Israel","以色列"],
	"21" => ["Italia","Italy","意大利"],
	"22" => ["Lettonia","Latvia","拉脱维亚"],
	"23" => ["Macedonia","Macedonia","水果沙拉"],
	"24" => ["Malta","Malta","砂浆"],
	"25" => ["Messico","Mexico","墨西哥"],
	"26" => ["Moldavia","Moldova","摩尔多瓦"],
	"27" => ["Olanda","Holland","荷兰"],
	"28" => ["Pakistan","Pakistan","巴基斯坦"],
	"29" => ["Peru","Peru","秘鲁"],
	"30" => ["Polonia","Poland","波兰"],
	"31" => ["Portogallo","Portugal","葡萄牙"],
	"32" => ["Regno Unito","United Kingdom","英国"],
	"33" => ["Romania","Romania","罗马尼亚"],
	"34" => ["Russia","Russia","俄国"],
	"35" => ["Serbia","Serbia","塞尔维亚"],
	"36" => ["Slovenia","Slovenia","斯洛文尼亚"],
	"37" => ["Spagna","Spain","西班牙"],
	"38" => ["Svizzera","Switzerland","瑞士"],
	"39" => ["Thailandia","Thailand","泰国"],
	"40" => ["Tunisia","Tunisia","突尼斯"],
	"41" => ["Turchia","Turkey","土耳其"],
	"42" => ["Ucraina","Ukraine","乌克兰"],
	"43" => ["Ungheria","Hungary","匈牙利"],
	"44" => ["Stati Uniti","United States","美国"],
	"45" => ["Vietnam","Vietnam","越南"],
}

for pk in 0..(map_countries.keys.length - 1) do
	_id = pk
	country = map_countries[pk.to_s]
	query = "INSERT INTO \"nazioni\" VALUES(#{_id},\"#{country[0]}\",\"#{country[1]}\",\"#{country[2]}\");"
    db.execute query
end

map_categories = {
	"0"  => ["Eventi Live","Live Events",""],
	"1"  => ["Intrattenimento","Entertainment",""],
	"2"  => ["Notizie","News",""],
	"3"  => ["Musica","Music",""],
	"4"  => ["Sport","Sport",""],
	"5"  => ["Generale","General",""],
	"6"  => ["Regionali","Regional",""],
	"7"  => ["Cinema","Cinema",""],
	"8"  => ["Cartoni","Cartoons",""],
	"9"  => ["Cultura & Religione","Culture & Religion",""],
	"10" => ["Tecnologia","Technology",""],
	"11" => ["Games","Games",""],
	"12" => ["Meteo","Weather",""],
	"13" => ["Fashion & Shopping","Fashion & Shopping",""],
}

for pk in 0..(map_categories.keys.length - 1) do
	_id = pk
	category = map_categories[pk.to_s]
	query = "INSERT INTO \"categorie\" VALUES(#{_id},\"#{category[0]}\",\"#{category[1]}\",\"#{category[2]}\");"
    db.execute query
end

db.close
