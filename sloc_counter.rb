# This script will count single lines of code SLOC
# The purpose to get lines of code for estimation of tasks
# The method is simple right now. It just reads in files and counts lines, rejecting lines of whitespace only.

# @param [String or Array of String] dir_to_check - directory(ies) to sweep
# @param [String] file_types - file extensions separated by commas (i.e. '{xml,cs,py,java}')
def count_slocs_in_dir dir_to_check, file_types = ''
  file_types = '.' + file_types unless file_types.empty?
  dirs_to_check = Array(dir_to_check)
  file_list = []
  dirs_to_check.each{|d| file_list += Dir[d+'/**/*' + file_types].reject {|fn| File.directory?(fn) } }
  #file_list = Dir[dir_to_check+'/**/*'].reject {|fn| File.directory?(fn) }

  # Rejects whitespace lines only
  # Does not detect comments yet
  def get_lines_of_code file_string
    lines = file_string.split("\n")
    non_empty_lines = lines.map{|s| s.strip}.reject{|s| s.empty?}
    non_empty_lines.size
  end

  sloc_counts = file_list.map{|f| get_lines_of_code(File.read(f))}
  total_sloc = sloc_counts.reduce :+
end
