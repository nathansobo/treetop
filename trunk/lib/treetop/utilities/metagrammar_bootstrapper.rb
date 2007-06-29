module Treetop
  class MetagrammarBootstrapper
  
    METAGRAMMAR_TREETOP_FILE_PATH = File.expand_path('metagrammar.treetop', "#{TREETOP_ROOT}/metagrammar/")
    NEOMETAGRAMMAR_TREETOP_FILE_PATH = File.expand_path('neometagrammar.treetop', "#{TREETOP_ROOT}/metagrammar/")
    METAGRAMMAR_DIRECTORY = "#{TREETOP_ROOT}/metagrammar"
    
    def self.generate_metagrammar
      FileUtils.copy(METAGRAMMAR_TREETOP_FILE_PATH, next_metagrammar_treetop_file_path)
      File.open(next_metagrammar_file_path, 'w') do |out_file|
        out_file.write(metagrammar_ruby)
      end
    end
    
    def self.next_metagrammar_file_path
      next_metagrammar_file_basename + '.rb'
    end
    
    def self.next_metagrammar_treetop_file_path
      next_metagrammar_file_basename + '.treetop'
    end
    
    def self.next_metagrammar_file_basename
      file_name = sprintf('%04d', latest_metagrammar_file_number + 1)
      "#{METAGRAMMAR_DIRECTORY}/#{file_name}"
    end
    
    
    def self.latest_metagrammar_file_number
      latest_metagrammar_file_path.match(/(\d\d\d\d)\.rb/)[1].to_i
    end
    
    def self.latest_metagrammar_file_path
      Dir.glob(METAGRAMMAR_DIRECTORY + "/*.rb").sort.last
    end
    
    def self.metagrammar_ruby
      result = parse_metagrammar
      raise "Unable to parse metagrammar.treetop with the a first generation Metagrammar" if result.failure?
      return result.to_ruby
    end
        
    def self.parse_metagrammar
      File.open(METAGRAMMAR_TREETOP_FILE_PATH, 'r') do |in_file|
        Metagrammar.new_parser.parse(in_file.read)
      end
    end
    
    # def self.evaluate_metagrammar
    #     eval(metagrammar_ruby)
    #   end
    # 
  end
end