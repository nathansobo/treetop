require "#{TREETOP_ROOT}/protometagrammar"

module Treetop
  class MetagrammarBootstrapper
  
    METAGRAMMAR_TREETOP_FILE_PATH = File.expand_path('metagrammar.treetop', "#{TREETOP_ROOT}/metagrammar/")
    METAGRAMMAR_RUBY_FILE_PATH = File.expand_path('metagrammar.rb', "#{TREETOP_ROOT}/metagrammar/")
    
    def self.bootstrap_with_protometagrammar
      File.open(METAGRAMMAR_TREETOP_FILE_PATH, 'r') do |in_file|
        metagrammar_from_proto = Protometagrammar.new.new_parser.parse(in_file.read).value

        in_file.rewind
        metagrammar = metagrammar_from_proto.new_parser.parse(in_file.read)
        
        File.open(METAGRAMMAR_RUBY_FILE_PATH, 'w') do |out_file|
          out_file.write("module Treetop\n" + metagrammar.to_ruby + "\nend")
        end
      end
    end
  end
end