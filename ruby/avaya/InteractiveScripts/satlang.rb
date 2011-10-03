module SatLang  
  
  def self.parse(input)
    raw_string = input
    command = ""
    response = ""
    not_empty = false
    clean_lines = []
    
    raw_string.split(/\e\[\d+\;\d+H/).each do |x|
      temp = x.gsub(/\e7|\e8|\e</, ' ').gsub(/\e.?\d{1,2}(;\d{1,2})?(\w)/, " ").split("\n")
      clean_lines.concat(temp.map { |y| y.strip })
    end
    clean_lines.delete_at(0)
    clean_lines.delete("")
    if (clean_lines[0] and clean_lines[0] =~ /have bean/)
      clean_lines.delete_at(0)
    end
    command = clean_lines[0].strip if clean_lines[0]
    temp = command.split(" ").last.strip if (command != "")
    begin
      clean_lines[1..-3].each do |i|
        not_empty = ((i.index(temp) != nil) or not_empty)
      end
    rescue
    end
    response = clean_lines[-2].strip if clean_lines[-2]
    
    return [command, response, (not not_empty)]
  end
  
end
