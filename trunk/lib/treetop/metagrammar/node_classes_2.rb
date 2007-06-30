module Treetop
  module MetagrammarNode
    class TreetopFile < SequenceSyntaxNode
      def to_ruby
        elements.map { |elt| elt.to_ruby }.join
      end
    end
  
    class ArbitraryCharacter < TerminalSyntaxNode
      def to_ruby
        text_value
      end
    end
  
    class GrammarNode < SequenceSyntaxNode
      def to_ruby
        "#{name} = ::Treetop::Grammar.new('#{name}')\n#{parsing_rule_sequence.to_ruby(self)}"
      end
  
      def name
        grammar_name.value
      end
    end
  
    class GrammarName < SequenceSyntaxNode
      def value
        elements[0].text_value.to_sym
      end
    end
  
    class ParsingRuleSequence < SequenceSyntaxNode
      def to_ruby(grammar_node)
        add_rules_ruby = rules.map {|rule| rule.add_rule_ruby(grammar_node)}
        add_rules_ruby.join("\n") + "\n"
      end

      def rules
        [head_rule] + tail_rules
      end
    end
  
    class Epsilon < TerminalSyntaxNode
      def to_ruby(grammar = nil)
        ''
      end
    end
  
    class ParsingRuleNode < SequenceSyntaxNode
      def to_ruby(grammar_node)
        "::Treetop::ParsingRule.new(#{nonterminal.to_ruby(grammar_node)}, #{parsing_expression.to_ruby(grammar_node)})"
      end
   
      def add_rule_ruby(grammar_node)
        "#{grammar_node.name}.add_parsing_rule(#{to_ruby(grammar_node)})"
      end
    end
    
    class Choice < SequenceSyntaxNode
      def to_ruby(grammar_node)
        alternatives_ruby = alternatives.map { |alternative| alternative.to_ruby(grammar_node) }
        "::Treetop::OrderedChoice.new([#{alternatives_ruby.join(', ')}])"
      end
    
      def alternatives
        [head_alternative] + tail_alternatives
      end
    
      def tail_alternatives
        elements[1].elements.map {|tail_element| tail_element.elements[3]}
      end
    end
    
     class Sequence < SequenceSyntaxNode
      def to_ruby(grammar_node)
        elements_ruby = sequence_elements.map {|element| element.to_ruby(grammar_node)}
        "::Treetop::Sequence.new([#{elements_ruby.join(', ')}])#{node_class_expression.to_ruby}#{trailing_block.to_ruby}"
      end
  
      def sequence_elements
        [head_element] + tail_elements
      end
    
      def tail_elements
        elements[1].elements.map {|tail_element| tail_element.elements[1]}
      end
    end
    
    class Primary < SequenceSyntaxNode
      def to_ruby(grammar_node)
        "#{instantiator_primary.to_ruby(grammar_node)}#{node_class_expression.to_ruby}#{trailing_block.to_ruby}"
      end    
    end
    
    class LabeledPrimary < SequenceSyntaxNode
      def to_ruby(grammar_node)
        "#{labeled_element.to_ruby(grammar_node)}#{label.to_ruby}"
      end
      
      def labeled_element
        elements[1]
      end
    end
    
    class InstantiatorPrimary < SequenceSyntaxNode
      def to_ruby(grammar_node)
        repetition_suffix.to_ruby(grammar_node, atomic)
      end
    end
    
    class PrefixedPrimary < SequenceSyntaxNode
      def to_ruby(grammar_node)
        prefix.to_ruby(grammar_node, prefixed_expression)
      end
    
      def prefixed_expression
        elements[1]
      end
    end
    
    class OptionalPrimary < SequenceSyntaxNode
      def to_ruby(grammar_node)
        "::Treetop::Optional.new(#{optional_expression.to_ruby(grammar_node)})"
      end
  
      def optional_expression
        elements[0]
      end
    end
    
    class Plus < TerminalSyntaxNode
      def to_ruby(grammar_node, repeated_expression)
        "::Treetop::OneOrMore.new(#{repeated_expression.to_ruby(grammar_node)})"
      end
    end
    
    class Star < TerminalSyntaxNode
      def to_ruby(grammar_node, repeated_expression)
        "::Treetop::ZeroOrMore.new(#{repeated_expression.to_ruby(grammar_node)})"
      end
    end
    
    class And < TerminalSyntaxNode
      def to_ruby(grammar_node, prefixed_expression)
        "::Treetop::AndPredicate.new(#{prefixed_expression.to_ruby(grammar_node)})"
      end
    end
    
    class Bang < TerminalSyntaxNode
      def to_ruby(grammar_node, prefixed_expression)
        "::Treetop::NotPredicate.new(#{prefixed_expression.to_ruby(grammar_node)})"
      end
    end
    
    class ParenthesizedInstantiator < SequenceSyntaxNode
      def to_ruby(grammar_node)
        instantiator.to_ruby(grammar_node)
      end
    end
    
    class ParenthesizedPropagator < SequenceSyntaxNode
      def to_ruby(grammar_node)
        propagator.to_ruby(grammar_node)
      end
    end
    
    class Nonterminal < SequenceSyntaxNode
      def to_ruby(grammar_node)
        "#{grammar_node.name}.nonterminal_symbol(:#{name})"
      end

      def name
        elements[1].text_value
      end
    end
    
    class DoubleQuotedString < SequenceSyntaxNode
      def to_ruby(grammar_node = nil)
        "::Treetop::TerminalSymbol.new(\"#{elements[1].text_value}\")"
      end
    end
      
    class SingleQuotedString < SequenceSyntaxNode
      def to_ruby(grammar_node = nil)
        "::Treetop::TerminalSymbol.new('#{elements[1].text_value}')"
      end
    end
    
    class CharacterClass < SequenceSyntaxNode
      def to_ruby(grammar_node = nil)
        "::Treetop::CharacterClass.new('#{characters}')"
      end
    
      def characters
        elements[1].text_value
      end
    end
    
    class AnythingSymbol < TerminalSyntaxNode
      def to_ruby(grammar_node = nil)
        '::Treetop::AnythingSymbol.new'
      end
    end
    
    class NodeClassExpression < SequenceSyntaxNode
      def to_ruby
        ".with_node_class(#{node_class_expression.text_value})"
      end
      
      def node_class_expression
        elements[2]
      end
    end
    
    class TrailingBlock < SequenceSyntaxNode
      def to_ruby
        " #{block.to_ruby}"
      end
    end
    
    class Block < SequenceSyntaxNode
      def to_ruby
        text_value
      end
    end
  end
end