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
      return "module Treetop\n#{gen_2_metagrammar_ruby}\nend"
    end
    
    def self.gen_2_metagrammar_ruby
      result = parse_metagrammar_with(gen_1_metagrammar)
      raise "Unable to parse metagrammar.treetop with the a first generation Metagrammar" if result.failure?
      result.to_ruby
    end
    
    def self.gen_1_metagrammar
      result = parse_metagrammar_with(Protometagrammar.new)
      raise "Unable to parse metagrammar.treetop with Protometagrammar" if result.failure?
      result.value
    end
    
    def self.parse_metagrammar_with(grammar)
      File.open(METAGRAMMAR_TREETOP_FILE_PATH, 'r') do |in_file|
        grammar.new_parser.parse(in_file.read)
      end
    end
  end
end