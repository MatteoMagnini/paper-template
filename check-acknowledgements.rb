#!/usr/bin/env ruby

# Script to check if a LaTeX file contains acknowledgements section
# and process it based on specific conditions.

# Check if filename is provided
if ARGV.length != 1
  puts "Usage: ruby script.rb <filename.tex>"
  exit 1
end

file_name = ARGV[0]
camera_ready_file = "#{file_name.sub(/\.tex$/, '')}-camera-ready.tex"

# Read the file
begin
  content = File.read(file_name)
rescue Errno::ENOENT
  puts "Error: File '#{file_name}' not found."
  exit 1
end

# Flag variables for different cases
has_no_acknowledgements_comment = content.include?("% NO ACKNOWLEDGEMENTS %")
# Define regex patterns to capture acknowledgements and funding sections
acknowledgements_regex = /
  (?<!%)
  \\(section|subsection|subsubsection|paragraph|subparagraph)\*?
  \s*\{\s*(Acknowledgement|Acknowledgements|Funding|Fundings|Thanks|Sponsorship|Sponsor)\s*\}
  .*?
  (?=\\(section|subsection|subsubsection|paragraph|subparagraph)|\z)
/imx
thanks_command_regex = /(?<!%)\b\\thanks\s*\{.*?\}/i
commented_acknowledgements_regex = /(^\s*%+\s*\\(section|subsection|subsubsection|paragraph|subparagraph)\s*\{\s*(Acknowledgement|Acknowledgements|Funding|Fundings|Thanks|Sponsorship|Sponsor)\s*\}.*?(?=\\(section|subsection|subsubsection|paragraph|subparagraph)|\z))/im
commented_thanks_command_regex = /(^\s*%+\s*\\thanks\s*\{.*?\})/i

# Flag variables for different cases
has_no_acknowledgements_comment = content.include?("% NO ACKNOWLEDGEMENTS %")
has_commented_ack_section = content.match?(commented_acknowledgements_regex) || content.match?(commented_thanks_command_regex)
has_uncommented_ack_section = content.match?(acknowledgements_regex) || content.match?(thanks_command_regex)

if has_no_acknowledgements_comment
  # Case 1: "% NO ACKNOWLEDGEMENTS %" is present, simply copy to camera-ready version
  File.write(camera_ready_file, content)
elsif has_uncommented_ack_section
  # Case 2: Un-commented acknowledgements/funding section is found
  puts "Warning: Acknowledgements or funding is already present in the peer review version."
  File.write(camera_ready_file, content)
elsif has_commented_ack_section
  # Case 3: Commented acknowledgements/funding section is found, uncomment it
  # For each match of the commented section, remove % symbols from each line in the section
  modified_content = content.gsub(commented_acknowledgements_regex) do |match|
    match.gsub(/^\s*%+\s*/, '')  # Remove % and leading whitespace from each line
  end.gsub(commented_thanks_command_regex) do |match|
    match.gsub(/^\s*%+\s*/, '')  # Remove % and leading whitespace from each line
  end
  File.write(camera_ready_file, modified_content)
else
  # Case 4: No acknowledgements section at all
  puts "Error: The file must contain an acknowledgements or funding section."
  exit 1
end

puts "Processing complete. Output saved to '#{camera_ready_file}'."
