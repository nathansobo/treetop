dir = File.dirname(__FILE__)
$:.unshift(File.join(dir, *%w[.. lib]))

require 'rubygems'
require 'ruby-prof'
require "treetop"

include Treetop

metagrammar_file_path = File.join(dir, *%w[.. lib treetop metagrammar metagrammar.treetop])
File.open(metagrammar_file_path, 'r') do |metagrammar_file|

  @parser = Metagrammar.new_parser
  # Profiling occurs here:
  result = RubyProf.profile do
    result = @parser.parse(metagrammar_file.read)
  end
    
  File.open(File.join(dir, *%w[profile.html]), 'w') do |profile_file|
    printer = RubyProf::GraphHtmlPrinter.new(result)
    printer.print(profile_file, 0)
  end
end