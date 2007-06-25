module Treetop
Metagrammar = Grammar.new('Metagrammar')
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:grammar), Sequence.new([TerminalSymbol.new('grammar'), Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:grammar_name), Metagrammar.nonterminal_symbol(:parsing_rule_sequence), Optional.new(Metagrammar.nonterminal_symbol(:space)), TerminalSymbol.new('end')]) {
      def to_ruby
        "#{name} = Grammar.new('#{name}')\n#{parsing_rule_sequence.to_ruby(self)}"
      end
      
      def name
        elements[2].value
      end
      
      def parsing_rule_sequence
        elements[3]
      end
    }))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:grammar_name), Sequence.new([Sequence.new([CharacterClass.new('A-Z'), ZeroOrMore.new(Metagrammar.nonterminal_symbol(:alphanumeric_char))]), Metagrammar.nonterminal_symbol(:space)]) {
      def value
        elements[0].text_value.to_sym
      end
    }))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:parsing_rule_sequence), OrderedChoice.new([Sequence.new([Metagrammar.nonterminal_symbol(:parsing_rule), ZeroOrMore.new(Sequence.new([Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:parsing_rule)]))]) {
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
    }, TerminalSymbol.new('') {
      def to_ruby(grammar)
        ''
      end
    }])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:parsing_rule), Sequence.new([TerminalSymbol.new('rule'), Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:nonterminal), Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:expression), Metagrammar.nonterminal_symbol(:space), TerminalSymbol.new('end')]) {
      def to_ruby(grammar_node)
        "ParsingRule.new(#{nonterminal.to_ruby(grammar_node)}, #{expression.to_ruby(grammar_node)})"
      end
       
      def add_rule_ruby(grammar_node)
        "#{grammar_node.name}.add_parsing_rule(#{to_ruby(grammar_node)})"
      end

      def nonterminal
         elements[2]
      end
      
      def expression
         elements[4]
      end
    }))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:expression), OrderedChoice.new([Metagrammar.nonterminal_symbol(:choice), Metagrammar.nonterminal_symbol(:sequence), Metagrammar.nonterminal_symbol(:primary)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:instantiator), OrderedChoice.new([Metagrammar.nonterminal_symbol(:sequence), Metagrammar.nonterminal_symbol(:instantiator_primary)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:propagator), OrderedChoice.new([Metagrammar.nonterminal_symbol(:choice), Metagrammar.nonterminal_symbol(:propagator_primary)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:choice), Sequence.new([Metagrammar.nonterminal_symbol(:alternative), OneOrMore.new(Sequence.new([Optional.new(Metagrammar.nonterminal_symbol(:space)), TerminalSymbol.new('/'), Optional.new(Metagrammar.nonterminal_symbol(:space)), Metagrammar.nonterminal_symbol(:alternative)]))]) {
      def to_ruby(grammar_node)
        alternatives_ruby = alternatives.map { |alternative| alternative.to_ruby(grammar_node) }
        "OrderedChoice.new([#{alternatives_ruby.join(', ')}])"
      end
      
      def alternatives
        [head_alternative] + tail_alternatives
      end
      
      def head_alternative
        elements[0]
      end
      
      def tail_alternatives
        elements[1].elements.map {|tail_element| tail_element.elements[3]}
      end
    }))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:sequence), Sequence.new([Metagrammar.nonterminal_symbol(:primary), OneOrMore.new(Sequence.new([Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:primary)])), Metagrammar.nonterminal_symbol(:trailing_block)]) {
      def to_ruby(grammar_node)
        elements_ruby = sequence_elements.map {|element| element.to_ruby(grammar_node)}
        "Sequence.new([#{elements_ruby.join(', ')}])#{trailing_block.to_ruby}"
      end
    
      def sequence_elements
        [head_element] + tail_elements
      end
      
      def head_element
        elements[0]
      end
      
      def tail_elements
        elements[1].elements.map {|tail_element| tail_element.elements[1]}
      end
      
      def trailing_block
        elements[2]
      end
    }))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:alternative), OrderedChoice.new([Metagrammar.nonterminal_symbol(:sequence), Metagrammar.nonterminal_symbol(:primary)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:primary), OrderedChoice.new([Sequence.new([Metagrammar.nonterminal_symbol(:instantiator_primary), Metagrammar.nonterminal_symbol(:trailing_block)]) {
      def to_ruby(grammar_node)
        "#{instantiator_primary.to_ruby(grammar_node)}#{trailing_block.to_ruby}"
      end
      
      def instantiator_primary
        elements[0]
      end
      
      def trailing_block
        elements[1]
      end
    }, Metagrammar.nonterminal_symbol(:propagator_primary)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:instantiator_primary), OrderedChoice.new([Sequence.new([Metagrammar.nonterminal_symbol(:atomic), Metagrammar.nonterminal_symbol(:repetition_suffix)]) {
      def to_ruby(grammar_node)
        repetition_suffix.to_ruby(grammar_node, atomic)
      end
      
      def atomic
        elements[0]
      end
      
      def repetition_suffix
        elements[1]
      end
    }, Metagrammar.nonterminal_symbol(:atomic_instantiator)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:propagator_primary), OrderedChoice.new([Sequence.new([Metagrammar.nonterminal_symbol(:prefix), OrderedChoice.new([Metagrammar.nonterminal_symbol(:instantiator_primary), Metagrammar.nonterminal_symbol(:atomic)])]) {
      def to_ruby(grammar_node)
        prefix.to_ruby(grammar_node, prefixed_expression)
      end
      
      def prefix
        elements[0]
      end
      
      def prefixed_expression
        elements[1]
      end
    }, Sequence.new([OrderedChoice.new([Metagrammar.nonterminal_symbol(:instantiator_primary), Metagrammar.nonterminal_symbol(:atomic)]), TerminalSymbol.new('?')]) {
      def to_ruby(grammar_node)
        "Optional.new(#{optional_expression.to_ruby(grammar_node)})"
      end
    
      def optional_expression
        elements[0]
      end
    }, Metagrammar.nonterminal_symbol(:atomic_propagator)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:repetition_suffix), OrderedChoice.new([TerminalSymbol.new('+') {
      def to_ruby(grammar_node, repeated_expression)
        "OneOrMore.new(#{repeated_expression.to_ruby(grammar_node)})"
      end
    }, TerminalSymbol.new('*') {
      def to_ruby(grammar_node, repeated_expression)
        "ZeroOrMore.new(#{repeated_expression.to_ruby(grammar_node)})"
      end
    }])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:prefix), OrderedChoice.new([TerminalSymbol.new('&') {
      def to_ruby(grammar_node, prefixed_expression)
        "AndPredicate.new(#{prefixed_expression.to_ruby(grammar_node)})"
      end
    }, TerminalSymbol.new('!') {
      def to_ruby(grammar_node, prefixed_expression)
        "NotPredicate.new(#{prefixed_expression.to_ruby(grammar_node)})"
      end
    }])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:atomic), OrderedChoice.new([Metagrammar.nonterminal_symbol(:atomic_instantiator), Metagrammar.nonterminal_symbol(:atomic_propagator)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:atomic_instantiator), OrderedChoice.new([Metagrammar.nonterminal_symbol(:terminal), Metagrammar.nonterminal_symbol(:parenthesized_instantiator)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:atomic_propagator), OrderedChoice.new([Metagrammar.nonterminal_symbol(:nonterminal), Metagrammar.nonterminal_symbol(:parenthesized_propagator)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:parenthesized_instantiator), Sequence.new([TerminalSymbol.new('('), Optional.new(Metagrammar.nonterminal_symbol(:space)), Metagrammar.nonterminal_symbol(:instantiator), Optional.new(Metagrammar.nonterminal_symbol(:space)), TerminalSymbol.new(')')]) {
      def to_ruby(grammar_node)
        instantiator.to_ruby(grammar_node)
      end
      
      def instantiator
        elements[2]
      end
    }))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:parenthesized_propagator), Sequence.new([TerminalSymbol.new('('), Optional.new(Metagrammar.nonterminal_symbol(:space)), Metagrammar.nonterminal_symbol(:propagator), Optional.new(Metagrammar.nonterminal_symbol(:space)), TerminalSymbol.new(')')]) {
      def to_ruby(grammar_node)
        propagator.to_ruby(grammar_node)
      end
      
      def propagator
        elements[2]
      end
    }))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:nonterminal), Sequence.new([NotPredicate.new(Metagrammar.nonterminal_symbol(:keyword)), Sequence.new([Metagrammar.nonterminal_symbol(:alpha_char), ZeroOrMore.new(Metagrammar.nonterminal_symbol(:alphanumeric_char))])]) {
      def name
        elements[1].text_value
      end
      
      def to_ruby(grammar_node)
        "#{grammar_node.name}.nonterminal_symbol(:#{name})"
      end
    }))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:terminal), OrderedChoice.new([Metagrammar.nonterminal_symbol(:single_quoted_string), Metagrammar.nonterminal_symbol(:double_quoted_string), Metagrammar.nonterminal_symbol(:character_class), Metagrammar.nonterminal_symbol(:anything_symbol)])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:double_quoted_string), Sequence.new([TerminalSymbol.new('"'), ZeroOrMore.new(Sequence.new([NotPredicate.new(TerminalSymbol.new('"')), OrderedChoice.new([TerminalSymbol.new('\"'), AnythingSymbol.new])])), TerminalSymbol.new('"')]) {
      def to_ruby(grammar_node = nil)
        "TerminalSymbol.new(\"#{elements[1].text_value}\")"
      end
    }))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:single_quoted_string), Sequence.new([TerminalSymbol.new("'"), ZeroOrMore.new(Sequence.new([NotPredicate.new(TerminalSymbol.new("'")), OrderedChoice.new([TerminalSymbol.new("\\'"), AnythingSymbol.new])])), TerminalSymbol.new("'")]) {
      def to_ruby(grammar_node = nil)
        "TerminalSymbol.new('#{elements[1].text_value}')"
      end
    }))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:character_class), Sequence.new([TerminalSymbol.new('['), OneOrMore.new(Sequence.new([NotPredicate.new(TerminalSymbol.new(']')), OrderedChoice.new([TerminalSymbol.new('\]'), AnythingSymbol.new])])), TerminalSymbol.new(']')]) {
      def to_ruby(grammar_node = nil)
        "CharacterClass.new('#{characters}')"
      end
      
      def characters
        elements[1].text_value
      end
    }))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:anything_symbol), TerminalSymbol.new('.') {
      def to_ruby(grammar_node = nil)
        'AnythingSymbol.new'
      end
    }))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:trailing_block), OrderedChoice.new([Sequence.new([Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:block)]) {
      def to_ruby
        " #{block.to_ruby}"
      end

      def block
        elements[1]
      end
    }, TerminalSymbol.new('') {
      def to_ruby
        ''
      end
    }])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:block), Sequence.new([TerminalSymbol.new('{'), ZeroOrMore.new(OrderedChoice.new([Metagrammar.nonterminal_symbol(:block), Sequence.new([NotPredicate.new(CharacterClass.new('{}')), AnythingSymbol.new])])), TerminalSymbol.new('}')]) {
      def to_ruby
        text_value
      end    
    }))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:keyword), Sequence.new([OrderedChoice.new([TerminalSymbol.new('rule'), TerminalSymbol.new('end')]), NotPredicate.new(Sequence.new([NotPredicate.new(Metagrammar.nonterminal_symbol(:space)), AnythingSymbol.new]))])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:alpha_char), CharacterClass.new('A-Za-z_')))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:alphanumeric_char), OrderedChoice.new([Metagrammar.nonterminal_symbol(:alpha_char), CharacterClass.new('0-9')])))
Metagrammar.add_parsing_rule(ParsingRule.new(Metagrammar.nonterminal_symbol(:space), OneOrMore.new(CharacterClass.new(' \t\n\r'))))

end