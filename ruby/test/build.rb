#!/usr/bin/env ruby

require "svn/repos"

def check_project(repos_uri)
	project = ""
	revision = ""
	user = ""
	datetime = ""
	timestamp = ""
	command = ""
	
	ctx = Svn::Client::Context.new
	
	project = repos_uri.split("/")[-1]
	revision = ctx.update(repos_uri)
	
	ctx.log(repos_uri, revision, "HEAD", 0, true, nil) do |changed_paths, rev, author, date, message|
		user = author
		datetime = date
		last_changed_time = Time.from_apr_time(date)
		timestamp = last_changed_time.to_i
		command = message.strip
	end
	
	old_revision = ""
	old_timestamp = ""
	begin
		f = File.open("#{project}.log", "rb")
		contents = f.read.split("|")
		old_revision = contents[3]
		old_timestamp = contents[2]
	rescue Exception => e
	end
	
	puts old_revision, old_timestamp
	
	# ex
	command = "BUILD"
	
	if (command == "BUILD" and )
		build_project
		
		File.open("#{project}.log", "w") do |f| 
			f.write "#{user}|#{datetime}|#{timestamp}|#{revision}"
		end
	end
end

def build_project
	puts "BUILD"
end

path = ARGV[0].chomp.sub(/\/$/, "")
check_project(path)