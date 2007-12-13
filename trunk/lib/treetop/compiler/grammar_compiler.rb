module Treetop
  module Compiler
    class GrammarCompiler
      def compile(source_path, target_path = source_path.gsub(/\.(treetop|tt)\Z/, '.rb'))
        File.open(target_path, 'w') do |target_file|
          target_file.write(ruby_source(source_path))
        end
      end
      
      def ruby_source(source_path)
        File.open(source_path) do |source_file|
          parser = MetagrammarParser.new
          result = parser.parse(source_file.read)
          unless result
            raise RuntimeError.new(parser.failure_reason)
          end
          result.compile
        end
      end
    end
  end

  def self.load(file)
    load_grammar file
  end
end
