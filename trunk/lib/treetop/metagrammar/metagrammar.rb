module Treetop
Metagrammar = Grammar.new('Metagrammar')
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:grammar), Sequence.new([TerminalSymbol.new('grammar'), Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:grammar_name), Metagrammar.nonterminal_symbol(:parsing_rule_sequence), Optional.new(Metagrammar.nonterminal_symbol(:space)), TerminalSymbol.new('end')]) do
      def to_ruby
        "#{name} = Grammar.new('#{name}')\n#{parsing_rule_sequence.to_ruby(self)}"
      end
      
      def name
        elements[2].value
      end
      
      def parsing_rule_sequence
        elements[3]
      end
    
end))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:grammar_name), Sequence.new([Sequence.new([CharacterClass.new('A-Z'), ZeroOrMore.new(Metagrammar.nonterminal_symbol(:alphanumeric_char))]), Metagrammar.nonterminal_symbol(:space)]) do
      def value
        elements[0].text_value.to_sym
      end
    
end))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:parsing_rule_sequence), OrderedChoice.new([Sequence.new([Metagrammar.nonterminal_symbol(:parsing_rule), ZeroOrMore.new(Sequence.new([Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:parsing_rule)]))]) do
      def to_ruby(grammar_node)
        add_rules_ruby = rules.map {|rule| rule.add_rule_ruby(grammar_node)}
        add_rules_ruby.join("\n") + "\n"
      end

      def rules
        [head_rule] + tail_rules
      end
      
      def head_rule
        elements[0]
      end
          
      def tail_rules
        elements[1].elements.map {|space_parsing_rule_sequence| space_parsing_rule_sequence.elements[1]}
      end
    
end, TerminalSymbol.new('') do
      def to_ruby(grammar)
        ''
      end
    
end])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:parsing_rule), Sequence.new([TerminalSymbol.new('rule'), Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:nonterminal_symbol), Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:ordered_choice), Metagrammar.nonterminal_symbol(:space), TerminalSymbol.new('end')]) do
      def to_ruby(grammar_node)
        "ParsingRule.new(#{nonterminal_symbol.to_ruby(grammar_node)}, #{parsing_expression.to_ruby(grammar_node)})"
      end
       
      def add_rule_ruby(grammar_node)
        "#{grammar_node.name}.add_parsing_rule(#{to_ruby(grammar_node)})"
      end

      def nonterminal_symbol
         elements[2]
      end
      
      def parsing_expression
         elements[4]
      end
    
end))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:ordered_choice), OrderedChoice.new([Sequence.new([Metagrammar.nonterminal_symbol(:sequence), OneOrMore.new(Sequence.new([Optional.new(Metagrammar.nonterminal_symbol(:space)), TerminalSymbol.new('/'), Optional.new(Metagrammar.nonterminal_symbol(:space)), Metagrammar.nonterminal_symbol(:sequence)]))]) do
      def to_ruby(grammar_node)
        alternatives_ruby = alternatives.map {|alternative| alternative.to_ruby(grammar_node)}
        "OrderedChoice.new([#{alternatives_ruby.join(', ')}])"
      end

      def alternatives
        [head_alternative] + tail_alternatives
      end
    
      def head_alternative
        elements[0]
      end
    
      def tail_alternatives
        elements[1].elements.map {|repeated_tail_sequence| repeated_tail_sequence.elements[3]}
      end
    
end, Metagrammar.nonterminal_symbol(:sequence)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:sequence), OrderedChoice.new([Sequence.new([Metagrammar.nonterminal_symbol(:primary), OneOrMore.new(Sequence.new([Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:primary)])), Metagrammar.nonterminal_symbol(:trailing_block)]) do
      
      def to_ruby(grammar_node)      
        elements_ruby = sequence_elements.map {|element| element.to_ruby(grammar_node)}
        sequence_ruby = "Sequence.new([#{elements_ruby.join(', ')}])"        
        trailing_block.to_ruby(sequence_ruby)
      end
      
      def sequence_elements
        [head_element] + tail_elements
      end

      def head_element
        elements[0]
      end

      def tail_elements
        elements[1].elements.map {|space_primary_sequence| space_primary_sequence.elements[1]}
      end
      
      def trailing_block
        elements[2]
      end
    
end, Metagrammar.nonterminal_symbol(:primary)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:parenthesized_ordered_choice), Sequence.new([TerminalSymbol.new('('), Optional.new(Metagrammar.nonterminal_symbol(:space)), Metagrammar.nonterminal_symbol(:ordered_choice), Optional.new(Metagrammar.nonterminal_symbol(:space)), TerminalSymbol.new(')'), Metagrammar.nonterminal_symbol(:trailing_block)]) do
      def to_ruby(grammar_node)
        trailing_block.to_ruby(nested_expression.to_ruby(grammar_node))
      end

      def nested_expression
        elements[2]
      end
 
      def trailing_block
        elements[5]
      end
    
end))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:primary), Sequence.new([Optional.new(Metagrammar.nonterminal_symbol(:prefix)), Sequence.new([OrderedChoice.new([Metagrammar.nonterminal_symbol(:parenthesized_ordered_choice), Metagrammar.nonterminal_symbol(:terminal_symbol), Metagrammar.nonterminal_symbol(:nonterminal_symbol)]), Optional.new(Metagrammar.nonterminal_symbol(:suffix))])]) do
      def to_ruby(grammar_node)
        ruby_source = primary_expression.to_ruby(grammar_node)
        ruby_source = suffix.to_ruby(ruby_source) unless suffix.epsilon?
        ruby_source = prefix.to_ruby(ruby_source) unless prefix.epsilon?
        ruby_source
      end

      def prefix
        elements[0]
      end
    
      def primary_expression
        elements[1].elements[0]
      end
    
      def suffix
        elements[1].elements[1]
      end
    
end))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:prefix), OrderedChoice.new([TerminalSymbol.new('&') do
      def to_ruby(subsequent_expression_ruby_source)
        "AndPredicate.new(#{subsequent_expression_ruby_source})"
      end
    
end, TerminalSymbol.new('!') do
      def to_ruby(subsequent_expression_ruby_source)
        "NotPredicate.new(#{subsequent_expression_ruby_source})"
      end
    
end])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:suffix), OrderedChoice.new([TerminalSymbol.new('*') do
      def to_ruby(preceding_expression_ruby_source)
        "ZeroOrMore.new(#{preceding_expression_ruby_source})"
      end
    
end, TerminalSymbol.new('+') do
      def to_ruby(preceding_expression_ruby_source)
        "OneOrMore.new(#{preceding_expression_ruby_source})"
      end
    
end, TerminalSymbol.new('?') do
      def to_ruby(preceding_expression_ruby_source)
        "Optional.new(#{preceding_expression_ruby_source})"
      end
    
end])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:nonterminal_symbol), Sequence.new([NotPredicate.new(Metagrammar.nonterminal_symbol(:keyword)), Sequence.new([Metagrammar.nonterminal_symbol(:alpha_char), ZeroOrMore.new(Metagrammar.nonterminal_symbol(:alphanumeric_char))])]) do
      def name
        elements[1].text_value
      end
      
      def to_ruby(grammar_node)
        "#{grammar_node.name}.nonterminal_symbol(:#{name})"
      end
    
end))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:alpha_char), CharacterClass.new('A-Za-z_')))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:alphanumeric_char), OrderedChoice.new([Metagrammar.nonterminal_symbol(:alpha_char), CharacterClass.new('0-9')])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:terminal_symbol), Sequence.new([Metagrammar.nonterminal_symbol(:terminal_symbol_prefix), Metagrammar.nonterminal_symbol(:trailing_block)]) do
      def to_ruby(grammar_node = nil)
        trailing_block.to_ruby(terminal_symbol.to_ruby)
      end

      def terminal_symbol
        elements[0]
      end
     
      def trailing_block
        elements[1]
      end
    
end))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:terminal_symbol_prefix), OrderedChoice.new([Metagrammar.nonterminal_symbol(:single_quoted_string), Metagrammar.nonterminal_symbol(:double_quoted_string), Metagrammar.nonterminal_symbol(:character_class), Metagrammar.nonterminal_symbol(:anything_symbol)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:double_quoted_string), Sequence.new([TerminalSymbol.new('"'), ZeroOrMore.new(Sequence.new([NotPredicate.new(TerminalSymbol.new('"')), OrderedChoice.new([TerminalSymbol.new('\"'), AnythingSymbol.new])])), TerminalSymbol.new('"')]) do
      def to_ruby
        "TerminalSymbol.new(\"#{elements[1].text_value}\")"
      end
    
end))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:single_quoted_string), Sequence.new([TerminalSymbol.new("'"), ZeroOrMore.new(Sequence.new([NotPredicate.new(TerminalSymbol.new("'")), OrderedChoice.new([TerminalSymbol.new("\\'"), AnythingSymbol.new])])), TerminalSymbol.new("'")]) do
      def to_ruby
        "TerminalSymbol.new('#{elements[1].text_value}')"
      end
    
end))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:trailing_block), OrderedChoice.new([Sequence.new([Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:block)]) do
      def to_ruby(preceding_expression_ruby_source)
        "#{preceding_expression_ruby_source} #{block.to_ruby}"
      end

      def block
        elements[1]
      end
    
end, TerminalSymbol.new('') do
      def to_ruby(preceding_expression_ruby_source)
        preceding_expression_ruby_source
      end
    
end])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:block), Sequence.new([TerminalSymbol.new('{'), ZeroOrMore.new(OrderedChoice.new([Metagrammar.nonterminal_symbol(:block), Sequence.new([NotPredicate.new(CharacterClass.new('{}')), AnythingSymbol.new])])), TerminalSymbol.new('}')]) do
      def to_ruby
        first_character = block_contents[0]
        last_character = block_contents[-1]
      
        "do#{newline_if_needed(first_character)}#{block_contents}#{newline_if_needed(last_character)}end"
      end
      
      def block_contents
        elements[1].text_value
      end
      
      def newline_if_needed(character)
        character == 10 ? "" : "\n"
      end
    
end))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:character_class), Sequence.new([TerminalSymbol.new('['), OneOrMore.new(Sequence.new([NotPredicate.new(TerminalSymbol.new(']')), OrderedChoice.new([TerminalSymbol.new('\]'), AnythingSymbol.new])])), TerminalSymbol.new(']')]) do
      def to_ruby
        "CharacterClass.new('#{characters}')"
      end
      
      def characters
        elements[1].text_value
      end
    
end))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:keyword), Sequence.new([OrderedChoice.new([TerminalSymbol.new('rule'), TerminalSymbol.new('end')]), NotPredicate.new(Sequence.new([NotPredicate.new(Metagrammar.nonterminal_symbol(:space)), AnythingSymbol.new]))])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:anything_symbol), TerminalSymbol.new('.') do
      def to_ruby
        'AnythingSymbol.new'
      end
    
end))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:space), OneOrMore.new(CharacterClass.new(' \t\n\r'))))

end