#!/usr/bin/env ruby

# Check if a new base name is provided
if ARGV.length != 1
  puts "Usage: ruby rename_paper.rb <new_base_name>"
  exit 1
end

new_name = ARGV[0]

# Define specific filenames for the LaTeX files, YAML file, and .gitignore
tex_file = "paper-xxxx-venue-topic.tex"
sty_file = "paper-xxxx-venue-topic.sty"
yaml_file = ".github/workflows/build-and-deploy-latex.yml"
gitignore_file = ".gitignore"

# Verify that the required .tex, .sty, YAML, and .gitignore files exist
unless File.exist?(tex_file) && File.exist?(sty_file) && File.exist?(yaml_file) && File.exist?(gitignore_file)
  puts "Error: One or more required files (#{tex_file}, #{sty_file}, #{yaml_file}, #{gitignore_file}) are missing."
  exit 1
end

# Extract the original base name from the .tex file
original_base_name = tex_file.sub(/\.tex$/, '')

# Define new file names based on the new base name
new_tex_file = "#{new_name}.tex"
new_sty_file = "#{new_name}.sty"

begin
  # Rename .tex and .sty files
  File.rename(tex_file, new_tex_file)
  File.rename(sty_file, new_sty_file)

  # Update \usepackage{...} in the .tex file
  tex_content = File.read(new_tex_file).gsub(/\\usepackage\{#{Regexp.escape(original_base_name)}\}/, "\\usepackage{#{new_name}}")
  # Remove the acknowledgments section if it’s commented out
  tex_content.gsub!(/^%\s*\\section\{(Acknowledgements|Fundings)\}.*(\n%.*)*\n\s*\n/, '')
  File.write(new_tex_file, tex_content)

  # Update PAPER_BASE_NAME in the YAML workflow file
  yaml_content = File.read(yaml_file).gsub(/PAPER_BASE_NAME:\s*#{Regexp.escape(original_base_name)}/, "PAPER_BASE_NAME: #{new_name}")
  # Remove the scheduled cron job if present
  yaml_content.gsub!(/^  schedule:.*?\n(?:    - cron:.*?\n)+/m, '')
  File.write(yaml_file, yaml_content)

  # Update the .gitignore file
  gitignore_content = File.read(gitignore_file).gsub(/#{Regexp.escape(original_base_name)}/, new_name)
  File.write(gitignore_file, gitignore_content)

  # Update bibtext_prettifier.rb file
  bibtex_prettifier_file = "bibtex_prettifier.rb"
  bibtex_prettifier_content = File.read(bibtex_prettifier_file).gsub(/tex_file = "#{Regexp.escape(original_base_name)}.tex"/, "tex_file = \"#{new_name}.tex\"")
  File.write(bibtex_prettifier_file, bibtex_prettifier_content)

  # Remove this script if everything is successful
  File.delete(__FILE__)

  puts "Successfully renamed files, updated references, and modified .gitignore with '#{new_name}'."
rescue => e
  puts "Error: #{e.message}"
  exit 1
end
