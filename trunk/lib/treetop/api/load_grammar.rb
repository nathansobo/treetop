class Object
  def load_grammar(treetop_file_path)
    treetop_file_path += ".treetop" unless treetop_file_path =~ /\.treetop$/
    
    File.open("#{treetop_file_path}", 'r') do |grammar_file|
      result = Metagrammar.new_parser.parse(grammar_file.read)
      
      if result.success?
        grammar = result.value
        Object.instance_eval { const_set(grammar.name, grammar) }
      else
        raise MalformedGrammarException.new(result.nested_failures)
      end
    end
  end
end