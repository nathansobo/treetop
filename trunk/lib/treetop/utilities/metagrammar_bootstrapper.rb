require "#{TREETOP_ROOT}/protometagrammar"

module Treetop
  class MetagrammarBootstrapper
  
    METAGRAMMAR_TREETOP_FILE_PATH = File.expand_path('metagrammar.treetop', "#{TREETOP_ROOT}/metagrammar/")
    NEOMETAGRAMMAR_TREETOP_FILE_PATH = File.expand_path('neometagrammar.treetop', "#{TREETOP_ROOT}/metagrammar/")
    METAGRAMMAR_RUBY_FILE_PATH = File.expand_path('metagrammar.rb', "#{TREETOP_ROOT}/metagrammar/")
    
    def self.generate_metagrammar
      File.open(METAGRAMMAR_RUBY_FILE_PATH, 'w') do |out_file|
        out_file.write(metagrammar_ruby)
      end
    end
    
    def self.evaluate_metagrammar
      eval(metagrammar_ruby)
    end
    
    def self.metagrammar_ruby
      File.open(METAGRAMMAR_TREETOP_FILE_PATH, 'r') do |in_file|
        metagrammar = gen_1_metagrammar.new_parser.parse(in_file.read)
        return "module Treetop\n#{metagrammar.to_ruby}\nend"
      end
    end
    
    def self.gen_1_metagrammar
      File.open(METAGRAMMAR_TREETOP_FILE_PATH, 'r') do |in_file|
        metagrammar_from_proto_result = Protometagrammar.new.new_parser.parse(in_file.read)
        raise "Could not parse Metagrammar with Protometagrammar" if metagrammar_from_proto_result.failure?
        metagrammar_from_proto_result.value
      end
    end
    
    def self.gen_1_neometagrammar
      File.open(NEOMETAGRAMMAR_TREETOP_FILE_PATH, 'r') do |in_file|
        metagrammar_from_proto_result = Protometagrammar.new.new_parser.parse(in_file.read)
        raise "Could not parse Metagrammar with Protometagrammar" if metagrammar_from_proto_result.failure?
        metagrammar_from_proto_result.value
      end
    end
    
    
  end
end