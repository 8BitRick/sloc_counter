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
  def get_lines_of_code file_string, file_types
    lines = file_string.split("\n")
    non_empty_lines = lines.map{|s| s.strip}.reject{|s| s.empty?}
    non_empty_lines.size

    # Removing C++, java, javascript style comments
    lines_wo_single_line_comments = non_empty_lines.reject{|s| s.size >= 2 && s[0..1] == '//' }
    # Removing ruby and python style comments
    lines_wo_single_line_comments = lines_wo_single_line_comments.reject{|s| s.size >= 1 && s[0] == '#' }

    # Remove block comments for C++, java, javascript
    nested_comment_level = 0
    has_some_code = false
    was_in_comment = false
    lines_no_comments = lines_wo_single_line_comments.select do |s|
      was_in_comment = nested_comment_level > 0
      # Remove the "s.size < 2" check if you want to also reject single character lines
      has_some_code = s.size < 2 || (s.size >= 2 && s[0..1] != '/*')
      num_comment_starts = s.scan('/*').count
      num_comment_stops = s.scan('*/').count
      nested_comment_level += num_comment_starts
      nested_comment_level -= num_comment_stops
      nested_comment_level = [nested_comment_level, 0].max # cap it at zero
      nested_comment_level <= 0 && (has_some_code && !was_in_comment)
    end
    lines_no_comments.size
  end

  sloc_counts = file_list.map{|f| get_lines_of_code(File.read(f), file_types)}
  total_sloc = sloc_counts.reduce :+
end
