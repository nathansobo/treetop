class Object
  def load_grammar(treetop_file_path)
    treetop_file_path += ".treetop" unless treetop_file_path =~ /\.treetop$/
    
    File.open("#{treetop_file_path}", 'r') do |grammar_file|
      result = Treetop::Metagrammar.new_parser.parse(grammar_file.read)
      
      if result.success?
        eval(result.to_ruby)
      else
        raise Treetop::MalformedGrammarException.new(result.nested_failures)
      end
    end
  end
end