git_path = "./git/test/"
last_ver = "f9e8e1f1"

puts "START\t" + Time.now.to_s

packages_path = Dir.pwd

cmd = "git --git-dir=#{git_path}.git rev-parse HEAD"
puts "CMD\t" + cmd

output = IO.popen(cmd)
package = output.readlines[0].to_s[0, 8]
puts "PKG\t" + package
package += ".zip"

cmd =  "cd #{git_path} ; "
cmd += "zip #{packages_path}/#{package} `git diff --name-only #{last_ver} | sort | uniq`"
puts "CMD\t" + cmd

output = IO.popen(cmd)
puts output.readlines

puts "END."