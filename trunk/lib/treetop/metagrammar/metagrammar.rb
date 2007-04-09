module Treetop
  metagrammar_parser = Protometagrammar.new.new_parser
  
  File.open(File.expand_path('metagrammar.treetop', File.dirname(__FILE__)), 'r') do |file|
    Metagrammar = metagrammar_parser.parse(file.read).value
  end
end