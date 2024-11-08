#!/usr/bin/env ruby

# Check if a new base name is provided
if ARGV.length != 1
  puts "Usage: ruby rename_paper.rb <new_base_name>"
  exit 1
end

new_name = ARGV[0]

# Define the workflow YAML file
yaml_file = ".github/workflows/build-and-deploy-latex.yml"

# Search for the .tex and .sty files matching the pattern
tex_file = Dir.glob("paper-*.tex").find { |f| f =~ /paper-\d{4}-\w+-\w+\.tex/ }
sty_file = Dir.glob("paper-*.sty").find { |f| f =~ /paper-\d{4}-\w+-\w+\.sty/ }

# Verify both files were found
if tex_file.nil? || sty_file.nil?
  puts "Error: Required .tex or .sty files not found with expected pattern 'paper-xxxx-venue-topic'."
  exit 1
end

# Extract the original base name
original_base_name = tex_file.sub(/\.tex$/, '')

# Define new file names based on the new base name
new_tex_file = "#{new_name}.tex"
new_sty_file = "#{new_name}.sty"

# Check if the YAML file exists
unless File.exist?(yaml_file)
  puts "Error: Workflow file '#{yaml_file}' not found."
  exit 1
end

begin
  # Rename .tex and .sty files
  File.rename(tex_file, new_tex_file)
  File.rename(sty_file, new_sty_file)

  # Update \usepackage{...} in the .tex file
  tex_content = File.read(new_tex_file).gsub(/\\usepackage\{#{Regexp.escape(original_base_name)}\}/, "\\usepackage{#{new_name}}")
  File.write(new_tex_file, tex_content)

  # Update PAPER_BASE_NAME in the YAML workflow file
  yaml_content = File.read(yaml_file).gsub(/PAPER_BASE_NAME:\s*#{Regexp.escape(original_base_name)}/, "PAPER_BASE_NAME: #{new_name}")
  File.write(yaml_file, yaml_content)

  # Remove this script if everything is successful
  File.delete(__FILE__)

  puts "Successfully renamed files and updated references to '#{new_name}'."
rescue => e
  puts "Error: #{e.message}"
  exit 1
end
