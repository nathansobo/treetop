module Treetop
Metagrammar = Treetop::Grammar.new('Metagrammar')
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:grammar), Treetop::Sequence.new([Treetop::TerminalSymbol.new('grammar'), Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:grammar_name), Metagrammar.nonterminal_symbol(:parsing_rule_sequence), Treetop::Optional.new(Metagrammar.nonterminal_symbol(:space)), Treetop::TerminalSymbol.new('end')]) {
      def to_ruby
        "#{name} = Treetop::Grammar.new('#{name}')\n#{parsing_rule_sequence.to_ruby(self)}"
      end
      
      def name
        elements[2].value
      end
      
      def parsing_rule_sequence
        elements[3]
      end
    }))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:grammar_name), Treetop::Sequence.new([Treetop::Sequence.new([Treetop::CharacterClass.new('A-Z'), Treetop::ZeroOrMore.new(Metagrammar.nonterminal_symbol(:alphanumeric_char))]), Metagrammar.nonterminal_symbol(:space)]) {
      def value
        elements[0].text_value.to_sym
      end
    }))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:parsing_rule_sequence), Treetop::OrderedChoice.new([Treetop::Sequence.new([Metagrammar.nonterminal_symbol(:parsing_rule), Treetop::ZeroOrMore.new(Treetop::Sequence.new([Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:parsing_rule)]))]) {
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
    }, Treetop::TerminalSymbol.new('') {
      def to_ruby(grammar)
        ''
      end
    }])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:parsing_rule), Treetop::Sequence.new([Treetop::TerminalSymbol.new('rule'), Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:nonterminal), Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:expression), Metagrammar.nonterminal_symbol(:space), Treetop::TerminalSymbol.new('end')]) {
      def to_ruby(grammar_node)
        "Treetop::ParsingRule.new(#{nonterminal.to_ruby(grammar_node)}, #{expression.to_ruby(grammar_node)})"
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
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:expression), Treetop::OrderedChoice.new([Metagrammar.nonterminal_symbol(:choice), Metagrammar.nonterminal_symbol(:sequence), Metagrammar.nonterminal_symbol(:primary)])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:instantiator), Treetop::OrderedChoice.new([Metagrammar.nonterminal_symbol(:sequence), Metagrammar.nonterminal_symbol(:instantiator_primary)])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:propagator), Treetop::OrderedChoice.new([Metagrammar.nonterminal_symbol(:choice), Metagrammar.nonterminal_symbol(:propagator_primary)])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:choice), Treetop::Sequence.new([Metagrammar.nonterminal_symbol(:alternative), Treetop::OneOrMore.new(Treetop::Sequence.new([Treetop::Optional.new(Metagrammar.nonterminal_symbol(:space)), Treetop::TerminalSymbol.new('/'), Treetop::Optional.new(Metagrammar.nonterminal_symbol(:space)), Metagrammar.nonterminal_symbol(:alternative)]))]) {
      def to_ruby(grammar_node)
        alternatives_ruby = alternatives.map { |alternative| alternative.to_ruby(grammar_node) }
        "Treetop::OrderedChoice.new([#{alternatives_ruby.join(', ')}])"
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
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:sequence), Treetop::Sequence.new([Metagrammar.nonterminal_symbol(:primary), Treetop::OneOrMore.new(Treetop::Sequence.new([Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:primary)])), Metagrammar.nonterminal_symbol(:trailing_block)]) {
      def to_ruby(grammar_node)
        elements_ruby = sequence_elements.map {|element| element.to_ruby(grammar_node)}
        "Treetop::Sequence.new([#{elements_ruby.join(', ')}])#{trailing_block.to_ruby}"
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
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:alternative), Treetop::OrderedChoice.new([Metagrammar.nonterminal_symbol(:sequence), Metagrammar.nonterminal_symbol(:primary)])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:primary), Treetop::OrderedChoice.new([Treetop::Sequence.new([Metagrammar.nonterminal_symbol(:instantiator_primary), Metagrammar.nonterminal_symbol(:trailing_block)]) {
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
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:instantiator_primary), Treetop::OrderedChoice.new([Treetop::Sequence.new([Metagrammar.nonterminal_symbol(:atomic), Metagrammar.nonterminal_symbol(:repetition_suffix)]) {
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
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:propagator_primary), Treetop::OrderedChoice.new([Treetop::Sequence.new([Metagrammar.nonterminal_symbol(:prefix), Treetop::OrderedChoice.new([Metagrammar.nonterminal_symbol(:instantiator_primary), Metagrammar.nonterminal_symbol(:atomic)])]) {
      def to_ruby(grammar_node)
        prefix.to_ruby(grammar_node, prefixed_expression)
      end
      
      def prefix
        elements[0]
      end
      
      def prefixed_expression
        elements[1]
      end
    }, Treetop::Sequence.new([Treetop::OrderedChoice.new([Metagrammar.nonterminal_symbol(:instantiator_primary), Metagrammar.nonterminal_symbol(:atomic)]), Treetop::TerminalSymbol.new('?')]) {
      def to_ruby(grammar_node)
        "Treetop::Optional.new(#{optional_expression.to_ruby(grammar_node)})"
      end
    
      def optional_expression
        elements[0]
      end
    }, Metagrammar.nonterminal_symbol(:atomic_propagator)])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:repetition_suffix), Treetop::OrderedChoice.new([Treetop::TerminalSymbol.new('+') {
      def to_ruby(grammar_node, repeated_expression)
        "Treetop::OneOrMore.new(#{repeated_expression.to_ruby(grammar_node)})"
      end
    }, Treetop::TerminalSymbol.new('*') {
      def to_ruby(grammar_node, repeated_expression)
        "Treetop::ZeroOrMore.new(#{repeated_expression.to_ruby(grammar_node)})"
      end
    }])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:prefix), Treetop::OrderedChoice.new([Treetop::TerminalSymbol.new('&') {
      def to_ruby(grammar_node, prefixed_expression)
        "Treetop::AndPredicate.new(#{prefixed_expression.to_ruby(grammar_node)})"
      end
    }, Treetop::TerminalSymbol.new('!') {
      def to_ruby(grammar_node, prefixed_expression)
        "Treetop::NotPredicate.new(#{prefixed_expression.to_ruby(grammar_node)})"
      end
    }])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:atomic), Treetop::OrderedChoice.new([Metagrammar.nonterminal_symbol(:atomic_instantiator), Metagrammar.nonterminal_symbol(:atomic_propagator)])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:atomic_instantiator), Treetop::OrderedChoice.new([Metagrammar.nonterminal_symbol(:terminal), Metagrammar.nonterminal_symbol(:parenthesized_instantiator)])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:atomic_propagator), Treetop::OrderedChoice.new([Metagrammar.nonterminal_symbol(:nonterminal), Metagrammar.nonterminal_symbol(:parenthesized_propagator)])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:parenthesized_instantiator), Treetop::Sequence.new([Treetop::TerminalSymbol.new('('), Treetop::Optional.new(Metagrammar.nonterminal_symbol(:space)), Metagrammar.nonterminal_symbol(:instantiator), Treetop::Optional.new(Metagrammar.nonterminal_symbol(:space)), Treetop::TerminalSymbol.new(')')]) {
      def to_ruby(grammar_node)
        instantiator.to_ruby(grammar_node)
      end
      
      def instantiator
        elements[2]
      end
    }))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:parenthesized_propagator), Treetop::Sequence.new([Treetop::TerminalSymbol.new('('), Treetop::Optional.new(Metagrammar.nonterminal_symbol(:space)), Metagrammar.nonterminal_symbol(:propagator), Treetop::Optional.new(Metagrammar.nonterminal_symbol(:space)), Treetop::TerminalSymbol.new(')')]) {
      def to_ruby(grammar_node)
        propagator.to_ruby(grammar_node)
      end
      
      def propagator
        elements[2]
      end
    }))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:nonterminal), Treetop::Sequence.new([Treetop::NotPredicate.new(Metagrammar.nonterminal_symbol(:keyword)), Treetop::Sequence.new([Metagrammar.nonterminal_symbol(:alpha_char), Treetop::ZeroOrMore.new(Metagrammar.nonterminal_symbol(:alphanumeric_char))])]) {
      def name
        elements[1].text_value
      end
      
      def to_ruby(grammar_node)
        "#{grammar_node.name}.nonterminal_symbol(:#{name})"
      end
    }))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:terminal), Treetop::OrderedChoice.new([Metagrammar.nonterminal_symbol(:single_quoted_string), Metagrammar.nonterminal_symbol(:double_quoted_string), Metagrammar.nonterminal_symbol(:character_class), Metagrammar.nonterminal_symbol(:anything_symbol)])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:double_quoted_string), Treetop::Sequence.new([Treetop::TerminalSymbol.new('"'), Treetop::ZeroOrMore.new(Treetop::Sequence.new([Treetop::NotPredicate.new(Treetop::TerminalSymbol.new('"')), Treetop::OrderedChoice.new([Treetop::TerminalSymbol.new('\"'), Treetop::AnythingSymbol.new])])), Treetop::TerminalSymbol.new('"')]) {
      def to_ruby(grammar_node = nil)
        "Treetop::TerminalSymbol.new(\"#{elements[1].text_value}\")"
      end
    }))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:single_quoted_string), Treetop::Sequence.new([Treetop::TerminalSymbol.new("'"), Treetop::ZeroOrMore.new(Treetop::Sequence.new([Treetop::NotPredicate.new(Treetop::TerminalSymbol.new("'")), Treetop::OrderedChoice.new([Treetop::TerminalSymbol.new("\\'"), Treetop::AnythingSymbol.new])])), Treetop::TerminalSymbol.new("'")]) {
      def to_ruby(grammar_node = nil)
        "Treetop::TerminalSymbol.new('#{elements[1].text_value}')"
      end
    }))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:character_class), Treetop::Sequence.new([Treetop::TerminalSymbol.new('['), Treetop::OneOrMore.new(Treetop::Sequence.new([Treetop::NotPredicate.new(Treetop::TerminalSymbol.new(']')), Treetop::OrderedChoice.new([Treetop::TerminalSymbol.new('\]'), Treetop::AnythingSymbol.new])])), Treetop::TerminalSymbol.new(']')]) {
      def to_ruby(grammar_node = nil)
        "Treetop::CharacterClass.new('#{characters}')"
      end
      
      def characters
        elements[1].text_value
      end
    }))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:anything_symbol), Treetop::TerminalSymbol.new('.') {
      def to_ruby(grammar_node = nil)
        'Treetop::AnythingSymbol.new'
      end
    }))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:trailing_block), Treetop::OrderedChoice.new([Treetop::Sequence.new([Metagrammar.nonterminal_symbol(:space), Metagrammar.nonterminal_symbol(:block)]) {
      def to_ruby
        " #{block.to_ruby}"
      end

      def block
        elements[1]
      end
    }, Treetop::TerminalSymbol.new('') {
      def to_ruby
        ''
      end
    }])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:block), Treetop::Sequence.new([Treetop::TerminalSymbol.new('{'), Treetop::ZeroOrMore.new(Treetop::OrderedChoice.new([Metagrammar.nonterminal_symbol(:block), Treetop::Sequence.new([Treetop::NotPredicate.new(Treetop::CharacterClass.new('{}')), Treetop::AnythingSymbol.new])])), Treetop::TerminalSymbol.new('}')]) {
      def to_ruby
        text_value
      end    
    }))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:keyword), Treetop::Sequence.new([Treetop::OrderedChoice.new([Treetop::TerminalSymbol.new('rule'), Treetop::TerminalSymbol.new('end')]), Treetop::NotPredicate.new(Treetop::Sequence.new([Treetop::NotPredicate.new(Metagrammar.nonterminal_symbol(:space)), Treetop::AnythingSymbol.new]))])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:alpha_char), Treetop::CharacterClass.new('A-Za-z_')))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:alphanumeric_char), Treetop::OrderedChoice.new([Metagrammar.nonterminal_symbol(:alpha_char), Treetop::CharacterClass.new('0-9')])))
Metagrammar.add_parsing_rule(Treetop::ParsingRule.new(Metagrammar.nonterminal_symbol(:space), Treetop::OneOrMore.new(Treetop::CharacterClass.new(' \t\n\r'))))

end