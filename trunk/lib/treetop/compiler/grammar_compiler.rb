module Treetop
  module Compiler
    class GrammarCompiler
      def compile(source_path, target_path = source_path.gsub(/treetop\Z/, 'rb'))
        File.open(target_path, 'w') do |target_file|
          target_file.write(ruby_source(source_path))
        end
      end
      
      def ruby_source(source_path)
        File.open(source_path) do |source_file|
          result = Metagrammar.new.parse(source_file.read)
          if result.failure?
            raise RuntimeError.new(result.nested_failures.map {|failure| failure.to_s}.join("\n"))
          end
          result.compile
        end
      end
    end
  end
end