module Treetop2
  module Compiler2
    class Metagrammar < ::Treetop2::Parser::CompiledParser
      include ::Treetop2::Parser
      def root
        puts 'Compiler2::Metagrammar being used to parse'
        _nt_treetop_file
      end
      def _nt_treetop_file
        s0, nr0, i0 = [], [], index
        loop do
          i1, nr1 = index, []
          r2 = self.send(:_nt_grammar)
          nr1 << r2
          if r2.success?
            r1 = r2
            r2.update_nested_results(nr1)
          else
            r3 = self.send(:_nt_arbitrary_character)
            nr1 << r3
            if r3.success?
              r1 = r3
              r3.update_nested_results(nr1)
            else
              self.index = i1
              r1 = ParseFailure.new(i1, nr1)
            end
          end
          nr0 << r1
          if r1.success?
            s0 << r1
          else
            break
          end
        end
        r0 = TreetopFile.new(input, i0...index, s0, nr0)
        return r0
      end
      module ArbitraryCharacter0
    
              def compile
                text_value
              end
        
      end
      def _nt_arbitrary_character
        r0 = parse_anything(SyntaxNode, ArbitraryCharacter0)
        return r0
      end
      def _nt_grammar
        i0, s0, nr0 = index, [], []
        r1 = parse_terminal('grammar', SyntaxNode)
        s0 << r1
        if r1.success?
          r2 = self.send(:_nt_space)
          s0 << r2
          if r2.success?
            r3 = self.send(:_nt_grammar_name)
            s0 << r3
            if r3.success?
              r4 = self.send(:_nt_space)
              s0 << r4
              if r4.success?
                r5 = self.send(:_nt_parsing_rule_sequence)
                s0 << r5
                if r5.success?
                  r7 = self.send(:_nt_space)
                  if r7.success?
                    r6 = r7
                  else
                    r6 = SyntaxNode.new(input, index...index, r7.nested_failures)
                  end
                  s0 << r6
                  if r6.success?
                    r8 = parse_terminal('end', SyntaxNode)
                    s0 << r8
                  end
                end
              end
            end
          end
        end
        if s0.last.success?
          r0 = (Grammar).new(input, i0...index, s0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      def _nt_grammar_name
        i0, s0, nr0 = index, [], []
        r1 = parse_char_class(/[A-Z]/, 'A-Z', SyntaxNode)
        s0 << r1
        if r1.success?
          s2, nr2, i2 = [], [], index
          loop do
            r3 = self.send(:_nt_alphanumeric_char)
            nr2 << r3
            if r3.success?
              s2 << r3
            else
              break
            end
          end
          r2 = SyntaxNode.new(input, i2...index, s2, nr2)
          s0 << r2
        end
        if s0.last.success?
          r0 = (SyntaxNode).new(input, i0...index, s0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      module ParsingRuleSequence0
    
              def rules
                [head_rule] + tail_rules
              end
          
              def head_rule
                elements[0]
              end
          
              def tail_rules
                elements[1].elements.map { |rule_with_space| rule_with_space.elements[1] }
              end
        
      end
      def _nt_parsing_rule_sequence
        i0, nr0 = index, []
        i1, s1, nr1 = index, [], []
        r2 = self.send(:_nt_parsing_rule)
        s1 << r2
        if r2.success?
          s3, nr3, i3 = [], [], index
          loop do
            i4, s4, nr4 = index, [], []
            r5 = self.send(:_nt_space)
            s4 << r5
            if r5.success?
              r6 = self.send(:_nt_parsing_rule)
              s4 << r6
            end
            if s4.last.success?
              r4 = (SyntaxNode).new(input, i4...index, s4)
            else
              self.index = i4
              r4 = ParseFailure.new(i4, s4)
            end
            nr3 << r4
            if r4.success?
              s3 << r4
            else
              break
            end
          end
          r3 = SyntaxNode.new(input, i3...index, s3, nr3)
          s1 << r3
        end
        if s1.last.success?
          r1 = (ParsingRuleSequence).new(input, i1...index, s1)
          r1.extend(ParsingRuleSequence0)
        else
          self.index = i1
          r1 = ParseFailure.new(i1, s1)
        end
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r7 = parse_terminal('', SyntaxNode)
          nr0 << r7
          if r7.success?
            r0 = r7
            r7.update_nested_results(nr0)
          else
            self.index = i0
            r0 = ParseFailure.new(i0, nr0)
          end
        end
        return r0
      end
      def _nt_parsing_rule
        i0, s0, nr0 = index, [], []
        r1 = parse_terminal('rule', SyntaxNode)
        s0 << r1
        if r1.success?
          r2 = self.send(:_nt_space)
          s0 << r2
          if r2.success?
            r3 = self.send(:_nt_nonterminal)
            s0 << r3
            if r3.success?
              r4 = self.send(:_nt_space)
              s0 << r4
              if r4.success?
                r5 = self.send(:_nt_parsing_expression)
                s0 << r5
                if r5.success?
                  r6 = self.send(:_nt_space)
                  s0 << r6
                  if r6.success?
                    r7 = parse_terminal('end', SyntaxNode)
                    s0 << r7
                  end
                end
              end
            end
          end
        end
        if s0.last.success?
          r0 = (ParsingRule).new(input, i0...index, s0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      def _nt_parsing_expression
        i0, nr0 = index, []
        r1 = self.send(:_nt_choice)
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r2 = self.send(:_nt_sequence)
          nr0 << r2
          if r2.success?
            r0 = r2
            r2.update_nested_results(nr0)
          else
            r3 = self.send(:_nt_primary)
            nr0 << r3
            if r3.success?
              r0 = r3
              r3.update_nested_results(nr0)
            else
              self.index = i0
              r0 = ParseFailure.new(i0, nr0)
            end
          end
        end
        return r0
      end
      module Choice0
    
              def head_alternative
                elements[0]
              end
          
              def tail_alternatives
                elements[1].elements.map {|alternative_with_slash| alternative_with_slash.elements[3]}
              end
          
              def alternatives
                [head_alternative] + tail_alternatives
              end
          
              def inline_modules
                (alternatives.map {|alt| alt.inline_modules }).flatten
              end
        
      end
      def _nt_choice
        i0, s0, nr0 = index, [], []
        r1 = self.send(:_nt_alternative)
        s0 << r1
        if r1.success?
          s2, nr2, i2 = [], [], index
          loop do
            i3, s3, nr3 = index, [], []
            r5 = self.send(:_nt_space)
            if r5.success?
              r4 = r5
            else
              r4 = SyntaxNode.new(input, index...index, r5.nested_failures)
            end
            s3 << r4
            if r4.success?
              r6 = parse_terminal('/', SyntaxNode)
              s3 << r6
              if r6.success?
                r8 = self.send(:_nt_space)
                if r8.success?
                  r7 = r8
                else
                  r7 = SyntaxNode.new(input, index...index, r8.nested_failures)
                end
                s3 << r7
                if r7.success?
                  r9 = self.send(:_nt_alternative)
                  s3 << r9
                end
              end
            end
            if s3.last.success?
              r3 = (SyntaxNode).new(input, i3...index, s3)
            else
              self.index = i3
              r3 = ParseFailure.new(i3, s3)
            end
            nr2 << r3
            if r3.success?
              s2 << r3
            else
              break
            end
          end
          if s2.empty?
            self.index = i2
            r2 = ParseFailure.new(i2, nr2)
          else
            r2 = SyntaxNode.new(input, i2...index, s2, nr2)
          end
          s0 << r2
        end
        if s0.last.success?
          r0 = (Choice).new(input, i0...index, s0)
          r0.extend(Choice0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      module Sequence0
    
              def head_element
                elements[0]
              end
          
              def tail_elements
                elements[1].elements.map {|element_with_space| element_with_space.elements[1] }
              end
          
              def sequence_elements
                [head_element] + tail_elements
              end
          
              def inline_modules
                (sequence_elements.map {|elt| elt.inline_modules}).flatten + node_class_declarations.inline_modules
              end
          
              def inline_module_name
                node_class_declarations.inline_module_name
              end
        
      end
      def _nt_sequence
        i0, s0, nr0 = index, [], []
        r1 = self.send(:_nt_sequence_primary)
        s0 << r1
        if r1.success?
          s2, nr2, i2 = [], [], index
          loop do
            i3, s3, nr3 = index, [], []
            r4 = self.send(:_nt_space)
            s3 << r4
            if r4.success?
              r5 = self.send(:_nt_sequence_primary)
              s3 << r5
            end
            if s3.last.success?
              r3 = (SyntaxNode).new(input, i3...index, s3)
            else
              self.index = i3
              r3 = ParseFailure.new(i3, s3)
            end
            nr2 << r3
            if r3.success?
              s2 << r3
            else
              break
            end
          end
          if s2.empty?
            self.index = i2
            r2 = ParseFailure.new(i2, nr2)
          else
            r2 = SyntaxNode.new(input, i2...index, s2, nr2)
          end
          s0 << r2
          if r2.success?
            r6 = self.send(:_nt_node_class_declarations)
            s0 << r6
          end
        end
        if s0.last.success?
          r0 = (Sequence).new(input, i0...index, s0)
          r0.extend(Sequence0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      def _nt_alternative
        i0, nr0 = index, []
        r1 = self.send(:_nt_sequence)
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r2 = self.send(:_nt_primary)
          nr0 << r2
          if r2.success?
            r0 = r2
            r2.update_nested_results(nr0)
          else
            self.index = i0
            r0 = ParseFailure.new(i0, nr0)
          end
        end
        return r0
      end
      module Primary0
    
              def compile(address, builder)
                prefix.compile(address, builder, self)
              end
          
              def predicated_expression
                atomic
              end
          
              def inline_modules
                atomic.inline_modules
              end
          
              def inline_module_name
                nil
              end
        
      end
      module Primary1
    
              def compile(address, builder)
                suffix.compile(address, builder, self)
              end
          
              def optional_expression
                elements[0]
              end
          
              def node_class
                node_class_declarations.node_class
              end
          
              def inline_modules
                atomic.inline_modules + node_class_declarations.inline_modules
              end
          
              def inline_module_name
                node_class_declarations.inline_module_name
              end
        
      end
      module Primary2
    
              def compile(address, builder)
                atomic.compile(address, builder, self)
              end
          
              def node_class
                node_class_declarations.node_class
              end
          
              def inline_modules
                atomic.inline_modules + node_class_declarations.inline_modules
              end
          
              def inline_module_name
                node_class_declarations.inline_module_name
              end
        
      end
      def _nt_primary
        i0, nr0 = index, []
        i1, s1, nr1 = index, [], []
        r2 = self.send(:_nt_prefix)
        s1 << r2
        if r2.success?
          r3 = self.send(:_nt_atomic)
          s1 << r3
        end
        if s1.last.success?
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(Primary0)
        else
          self.index = i1
          r1 = ParseFailure.new(i1, s1)
        end
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          i4, s4, nr4 = index, [], []
          r5 = self.send(:_nt_atomic)
          s4 << r5
          if r5.success?
            r6 = self.send(:_nt_suffix)
            s4 << r6
            if r6.success?
              r7 = self.send(:_nt_node_class_declarations)
              s4 << r7
            end
          end
          if s4.last.success?
            r4 = (SyntaxNode).new(input, i4...index, s4)
            r4.extend(Primary1)
          else
            self.index = i4
            r4 = ParseFailure.new(i4, s4)
          end
          nr0 << r4
          if r4.success?
            r0 = r4
            r4.update_nested_results(nr0)
          else
            i8, s8, nr8 = index, [], []
            r9 = self.send(:_nt_atomic)
            s8 << r9
            if r9.success?
              r10 = self.send(:_nt_node_class_declarations)
              s8 << r10
            end
            if s8.last.success?
              r8 = (SyntaxNode).new(input, i8...index, s8)
              r8.extend(Primary2)
            else
              self.index = i8
              r8 = ParseFailure.new(i8, s8)
            end
            nr0 << r8
            if r8.success?
              r0 = r8
              r8.update_nested_results(nr0)
            else
              self.index = i0
              r0 = ParseFailure.new(i0, nr0)
            end
          end
        end
        return r0
      end
      module SequencePrimary0
    
              def compile(lexical_address, builder)
                prefix.compile(lexical_address, builder, self)
              end
          
              def predicated_expression
                elements[1]
              end
          
              def inline_modules
                atomic.inline_modules
              end
          
              def inline_module_name
                nil
              end
        
      end
      module SequencePrimary1
    
              def compile(lexical_address, builder)
                suffix.compile(lexical_address, builder, self)
              end
          
              def node_class
                'SyntaxNode'
              end
          
              def inline_modules
                atomic.inline_modules
              end
          
              def inline_module_name
                nil
              end
        
      end
      def _nt_sequence_primary
        i0, nr0 = index, []
        i1, s1, nr1 = index, [], []
        r2 = self.send(:_nt_prefix)
        s1 << r2
        if r2.success?
          r3 = self.send(:_nt_atomic)
          s1 << r3
        end
        if s1.last.success?
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(SequencePrimary0)
        else
          self.index = i1
          r1 = ParseFailure.new(i1, s1)
        end
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          i4, s4, nr4 = index, [], []
          r5 = self.send(:_nt_atomic)
          s4 << r5
          if r5.success?
            r6 = self.send(:_nt_suffix)
            s4 << r6
          end
          if s4.last.success?
            r4 = (SyntaxNode).new(input, i4...index, s4)
            r4.extend(SequencePrimary1)
          else
            self.index = i4
            r4 = ParseFailure.new(i4, s4)
          end
          nr0 << r4
          if r4.success?
            r0 = r4
            r4.update_nested_results(nr0)
          else
            r7 = self.send(:_nt_atomic)
            nr0 << r7
            if r7.success?
              r0 = r7
              r7.update_nested_results(nr0)
            else
              self.index = i0
              r0 = ParseFailure.new(i0, nr0)
            end
          end
        end
        return r0
      end
      def _nt_suffix
        i0, nr0 = index, []
        r1 = self.send(:_nt_repetition_suffix)
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r2 = self.send(:_nt_optional_suffix)
          nr0 << r2
          if r2.success?
            r0 = r2
            r2.update_nested_results(nr0)
          else
            self.index = i0
            r0 = ParseFailure.new(i0, nr0)
          end
        end
        return r0
      end
      def _nt_optional_suffix
        r0 = parse_terminal('?', Optional)
        return r0
      end
      module NodeClassDeclarations0
    
              def node_class
                node_class_expression.node_class
              end
          
              def inline_modules
                trailing_inline_module.inline_modules
              end
          
              def inline_module
                trailing_inline_module.inline_module
              end
          
              def inline_module_name
                inline_module.module_name if inline_module
              end
        
      end
      def _nt_node_class_declarations
        i0, s0, nr0 = index, [], []
        r1 = self.send(:_nt_node_class_expression)
        s0 << r1
        if r1.success?
          r2 = self.send(:_nt_trailing_inline_module)
          s0 << r2
        end
        if s0.last.success?
          r0 = (SyntaxNode).new(input, i0...index, s0)
          r0.extend(NodeClassDeclarations0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      def _nt_repetition_suffix
        i0, nr0 = index, []
        r1 = parse_terminal('+', OneOrMore)
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r2 = parse_terminal('*', ZeroOrMore)
          nr0 << r2
          if r2.success?
            r0 = r2
            r2.update_nested_results(nr0)
          else
            self.index = i0
            r0 = ParseFailure.new(i0, nr0)
          end
        end
        return r0
      end
      def _nt_prefix
        i0, nr0 = index, []
        r1 = parse_terminal('&', AndPredicate)
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r2 = parse_terminal('!', NotPredicate)
          nr0 << r2
          if r2.success?
            r0 = r2
            r2.update_nested_results(nr0)
          else
            self.index = i0
            r0 = ParseFailure.new(i0, nr0)
          end
        end
        return r0
      end
      def _nt_atomic
        i0, nr0 = index, []
        r1 = self.send(:_nt_terminal)
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r2 = self.send(:_nt_nonterminal)
          nr0 << r2
          if r2.success?
            r0 = r2
            r2.update_nested_results(nr0)
          else
            r3 = self.send(:_nt_parenthesized_expression)
            nr0 << r3
            if r3.success?
              r0 = r3
              r3.update_nested_results(nr0)
            else
              self.index = i0
              r0 = ParseFailure.new(i0, nr0)
            end
          end
        end
        return r0
      end
      module ParenthesizedExpression0
    
              def inline_modules
                parsing_expression.inline_modules
              end
        
      end
      def _nt_parenthesized_expression
        i0, s0, nr0 = index, [], []
        r1 = parse_terminal('(', SyntaxNode)
        s0 << r1
        if r1.success?
          r3 = self.send(:_nt_space)
          if r3.success?
            r2 = r3
          else
            r2 = SyntaxNode.new(input, index...index, r3.nested_failures)
          end
          s0 << r2
          if r2.success?
            r4 = self.send(:_nt_parsing_expression)
            s0 << r4
            if r4.success?
              r6 = self.send(:_nt_space)
              if r6.success?
                r5 = r6
              else
                r5 = SyntaxNode.new(input, index...index, r6.nested_failures)
              end
              s0 << r5
              if r5.success?
                r7 = parse_terminal(')', SyntaxNode)
                s0 << r7
              end
            end
          end
        end
        if s0.last.success?
          r0 = (ParenthesizedExpression).new(input, i0...index, s0)
          r0.extend(ParenthesizedExpression0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      def _nt_nonterminal
        i0, s0, nr0 = index, [], []
        i1 = index
        r2 = self.send(:_nt_keyword_inside_grammar)
        if r2.success?
          r1 = ParseFailure.new(i1, r2.nested_failures)
        else
          self.index = i1
          r1 = SyntaxNode.new(input, index...index, r2.nested_failures)
        end
        s0 << r1
        if r1.success?
          i3, s3, nr3 = index, [], []
          r4 = self.send(:_nt_alpha_char)
          s3 << r4
          if r4.success?
            s5, nr5, i5 = [], [], index
            loop do
              r6 = self.send(:_nt_alphanumeric_char)
              nr5 << r6
              if r6.success?
                s5 << r6
              else
                break
              end
            end
            r5 = SyntaxNode.new(input, i5...index, s5, nr5)
            s3 << r5
          end
          if s3.last.success?
            r3 = (SyntaxNode).new(input, i3...index, s3)
          else
            self.index = i3
            r3 = ParseFailure.new(i3, s3)
          end
          s0 << r3
        end
        if s0.last.success?
          r0 = (Nonterminal).new(input, i0...index, s0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      def _nt_terminal
        i0, nr0 = index, []
        r1 = self.send(:_nt_single_quoted_string)
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r2 = self.send(:_nt_double_quoted_string)
          nr0 << r2
          if r2.success?
            r0 = r2
            r2.update_nested_results(nr0)
          else
            r3 = self.send(:_nt_character_class)
            nr0 << r3
            if r3.success?
              r0 = r3
              r3.update_nested_results(nr0)
            else
              r4 = self.send(:_nt_anything_symbol)
              nr0 << r4
              if r4.success?
                r0 = r4
                r4.update_nested_results(nr0)
              else
                self.index = i0
                r0 = ParseFailure.new(i0, nr0)
              end
            end
          end
        end
        return r0
      end
      def _nt_double_quoted_string
        i0, s0, nr0 = index, [], []
        r1 = parse_terminal('"', SyntaxNode)
        s0 << r1
        if r1.success?
          s2, nr2, i2 = [], [], index
          loop do
            i3, s3, nr3 = index, [], []
            i4 = index
            r5 = parse_terminal('"', SyntaxNode)
            if r5.success?
              r4 = ParseFailure.new(i4, r5.nested_failures)
            else
              self.index = i4
              r4 = SyntaxNode.new(input, index...index, r5.nested_failures)
            end
            s3 << r4
            if r4.success?
              i6, nr6 = index, []
              r7 = parse_terminal("\\\\", SyntaxNode)
              nr6 << r7
              if r7.success?
                r6 = r7
                r7.update_nested_results(nr6)
              else
                r8 = parse_terminal('\"', SyntaxNode)
                nr6 << r8
                if r8.success?
                  r6 = r8
                  r8.update_nested_results(nr6)
                else
                  r9 = parse_anything(SyntaxNode)
                  nr6 << r9
                  if r9.success?
                    r6 = r9
                    r9.update_nested_results(nr6)
                  else
                    self.index = i6
                    r6 = ParseFailure.new(i6, nr6)
                  end
                end
              end
              s3 << r6
            end
            if s3.last.success?
              r3 = (SyntaxNode).new(input, i3...index, s3)
            else
              self.index = i3
              r3 = ParseFailure.new(i3, s3)
            end
            nr2 << r3
            if r3.success?
              s2 << r3
            else
              break
            end
          end
          r2 = SyntaxNode.new(input, i2...index, s2, nr2)
          s0 << r2
          if r2.success?
            r10 = parse_terminal('"', SyntaxNode)
            s0 << r10
          end
        end
        if s0.last.success?
          r0 = (Terminal).new(input, i0...index, s0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      def _nt_single_quoted_string
        i0, s0, nr0 = index, [], []
        r1 = parse_terminal("'", SyntaxNode)
        s0 << r1
        if r1.success?
          s2, nr2, i2 = [], [], index
          loop do
            i3, s3, nr3 = index, [], []
            i4 = index
            r5 = parse_terminal("'", SyntaxNode)
            if r5.success?
              r4 = ParseFailure.new(i4, r5.nested_failures)
            else
              self.index = i4
              r4 = SyntaxNode.new(input, index...index, r5.nested_failures)
            end
            s3 << r4
            if r4.success?
              i6, nr6 = index, []
              r7 = parse_terminal("\\\\", SyntaxNode)
              nr6 << r7
              if r7.success?
                r6 = r7
                r7.update_nested_results(nr6)
              else
                r8 = parse_terminal("\\'", SyntaxNode)
                nr6 << r8
                if r8.success?
                  r6 = r8
                  r8.update_nested_results(nr6)
                else
                  r9 = parse_anything(SyntaxNode)
                  nr6 << r9
                  if r9.success?
                    r6 = r9
                    r9.update_nested_results(nr6)
                  else
                    self.index = i6
                    r6 = ParseFailure.new(i6, nr6)
                  end
                end
              end
              s3 << r6
            end
            if s3.last.success?
              r3 = (SyntaxNode).new(input, i3...index, s3)
            else
              self.index = i3
              r3 = ParseFailure.new(i3, s3)
            end
            nr2 << r3
            if r3.success?
              s2 << r3
            else
              break
            end
          end
          r2 = SyntaxNode.new(input, i2...index, s2, nr2)
          s0 << r2
          if r2.success?
            r10 = parse_terminal("'", SyntaxNode)
            s0 << r10
          end
        end
        if s0.last.success?
          r0 = (Terminal).new(input, i0...index, s0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      def _nt_character_class
        i0, s0, nr0 = index, [], []
        r1 = parse_terminal('[', SyntaxNode)
        s0 << r1
        if r1.success?
          s2, nr2, i2 = [], [], index
          loop do
            i3, s3, nr3 = index, [], []
            i4 = index
            r5 = parse_terminal(']', SyntaxNode)
            if r5.success?
              r4 = ParseFailure.new(i4, r5.nested_failures)
            else
              self.index = i4
              r4 = SyntaxNode.new(input, index...index, r5.nested_failures)
            end
            s3 << r4
            if r4.success?
              i6, nr6 = index, []
              r7 = parse_terminal('\]', SyntaxNode)
              nr6 << r7
              if r7.success?
                r6 = r7
                r7.update_nested_results(nr6)
              else
                r8 = parse_anything(SyntaxNode)
                nr6 << r8
                if r8.success?
                  r6 = r8
                  r8.update_nested_results(nr6)
                else
                  self.index = i6
                  r6 = ParseFailure.new(i6, nr6)
                end
              end
              s3 << r6
            end
            if s3.last.success?
              r3 = (SyntaxNode).new(input, i3...index, s3)
            else
              self.index = i3
              r3 = ParseFailure.new(i3, s3)
            end
            nr2 << r3
            if r3.success?
              s2 << r3
            else
              break
            end
          end
          if s2.empty?
            self.index = i2
            r2 = ParseFailure.new(i2, nr2)
          else
            r2 = SyntaxNode.new(input, i2...index, s2, nr2)
          end
          s0 << r2
          if r2.success?
            r9 = parse_terminal(']', SyntaxNode)
            s0 << r9
          end
        end
        if s0.last.success?
          r0 = (CharacterClass).new(input, i0...index, s0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      def _nt_anything_symbol
        r0 = parse_terminal('.', AnythingSymbol)
        return r0
      end
      module NodeClassExpression0
    
              def node_class
                elements[2].text_value
              end
        
      end
      module NodeClassExpression1
    
              def node_class
                'SyntaxNode'
              end
        
      end
      def _nt_node_class_expression
        i0, nr0 = index, []
        i1, s1, nr1 = index, [], []
        r2 = self.send(:_nt_space)
        s1 << r2
        if r2.success?
          r3 = parse_terminal('<', SyntaxNode)
          s1 << r3
          if r3.success?
            s4, nr4, i4 = [], [], index
            loop do
              i5, s5, nr5 = index, [], []
              i6 = index
              r7 = parse_terminal('>', SyntaxNode)
              if r7.success?
                r6 = ParseFailure.new(i6, r7.nested_failures)
              else
                self.index = i6
                r6 = SyntaxNode.new(input, index...index, r7.nested_failures)
              end
              s5 << r6
              if r6.success?
                r8 = parse_anything(SyntaxNode)
                s5 << r8
              end
              if s5.last.success?
                r5 = (SyntaxNode).new(input, i5...index, s5)
              else
                self.index = i5
                r5 = ParseFailure.new(i5, s5)
              end
              nr4 << r5
              if r5.success?
                s4 << r5
              else
                break
              end
            end
            if s4.empty?
              self.index = i4
              r4 = ParseFailure.new(i4, nr4)
            else
              r4 = SyntaxNode.new(input, i4...index, s4, nr4)
            end
            s1 << r4
            if r4.success?
              r9 = parse_terminal('>', SyntaxNode)
              s1 << r9
            end
          end
        end
        if s1.last.success?
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(NodeClassExpression0)
        else
          self.index = i1
          r1 = ParseFailure.new(i1, s1)
        end
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r10 = parse_terminal('', SyntaxNode, NodeClassExpression1)
          nr0 << r10
          if r10.success?
            r0 = r10
            r10.update_nested_results(nr0)
          else
            self.index = i0
            r0 = ParseFailure.new(i0, nr0)
          end
        end
        return r0
      end
      module TrailingInlineModule0
    
              def inline_modules
                [inline_module]
              end
                    
              def inline_module_name
                inline_module.module_name
              end
        
      end
      module TrailingInlineModule1
    
              def inline_modules
                []
              end
          
              def inline_module
                nil 
              end
          
              def inline_module_name
                nil
              end
        
      end
      def _nt_trailing_inline_module
        i0, nr0 = index, []
        i1, s1, nr1 = index, [], []
        r2 = self.send(:_nt_space)
        s1 << r2
        if r2.success?
          r3 = self.send(:_nt_inline_module)
          s1 << r3
        end
        if s1.last.success?
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(TrailingInlineModule0)
        else
          self.index = i1
          r1 = ParseFailure.new(i1, s1)
        end
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r4 = parse_terminal('', SyntaxNode, TrailingInlineModule1)
          nr0 << r4
          if r4.success?
            r0 = r4
            r4.update_nested_results(nr0)
          else
            self.index = i0
            r0 = ParseFailure.new(i0, nr0)
          end
        end
        return r0
      end
      def _nt_inline_module
        i0, s0, nr0 = index, [], []
        r1 = parse_terminal('{', SyntaxNode)
        s0 << r1
        if r1.success?
          s2, nr2, i2 = [], [], index
          loop do
            i3, nr3 = index, []
            r4 = self.send(:_nt_inline_module)
            nr3 << r4
            if r4.success?
              r3 = r4
              r4.update_nested_results(nr3)
            else
              i5, s5, nr5 = index, [], []
              i6 = index
              r7 = parse_char_class(/[{}]/, '{}', SyntaxNode)
              if r7.success?
                r6 = ParseFailure.new(i6, r7.nested_failures)
              else
                self.index = i6
                r6 = SyntaxNode.new(input, index...index, r7.nested_failures)
              end
              s5 << r6
              if r6.success?
                r8 = parse_anything(SyntaxNode)
                s5 << r8
              end
              if s5.last.success?
                r5 = (SyntaxNode).new(input, i5...index, s5)
              else
                self.index = i5
                r5 = ParseFailure.new(i5, s5)
              end
              nr3 << r5
              if r5.success?
                r3 = r5
                r5.update_nested_results(nr3)
              else
                self.index = i3
                r3 = ParseFailure.new(i3, nr3)
              end
            end
            nr2 << r3
            if r3.success?
              s2 << r3
            else
              break
            end
          end
          r2 = SyntaxNode.new(input, i2...index, s2, nr2)
          s0 << r2
          if r2.success?
            r9 = parse_terminal('}', SyntaxNode)
            s0 << r9
          end
        end
        if s0.last.success?
          r0 = (InlineModule).new(input, i0...index, s0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      def _nt_keyword_inside_grammar
        i0, s0, nr0 = index, [], []
        i1, nr1 = index, []
        r2 = parse_terminal('rule', SyntaxNode)
        nr1 << r2
        if r2.success?
          r1 = r2
          r2.update_nested_results(nr1)
        else
          r3 = parse_terminal('end', SyntaxNode)
          nr1 << r3
          if r3.success?
            r1 = r3
            r3.update_nested_results(nr1)
          else
            self.index = i1
            r1 = ParseFailure.new(i1, nr1)
          end
        end
        s0 << r1
        if r1.success?
          i4 = index
          r5 = self.send(:_nt_non_space_char)
          if r5.success?
            r4 = ParseFailure.new(i4, r5.nested_failures)
          else
            self.index = i4
            r4 = SyntaxNode.new(input, index...index, r5.nested_failures)
          end
          s0 << r4
        end
        if s0.last.success?
          r0 = (SyntaxNode).new(input, i0...index, s0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      def _nt_non_space_char
        i0, s0, nr0 = index, [], []
        i1 = index
        r2 = self.send(:_nt_space)
        if r2.success?
          r1 = ParseFailure.new(i1, r2.nested_failures)
        else
          self.index = i1
          r1 = SyntaxNode.new(input, index...index, r2.nested_failures)
        end
        s0 << r1
        if r1.success?
          r3 = parse_anything(SyntaxNode)
          s0 << r3
        end
        if s0.last.success?
          r0 = (SyntaxNode).new(input, i0...index, s0)
        else
          self.index = i0
          r0 = ParseFailure.new(i0, s0)
        end
        return r0
      end
      def _nt_alpha_char
        r0 = parse_char_class(/[A-Za-z_]/, 'A-Za-z_', SyntaxNode)
        return r0
      end
      def _nt_alphanumeric_char
        i0, nr0 = index, []
        r1 = self.send(:_nt_alpha_char)
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r2 = parse_char_class(/[0-9]/, '0-9', SyntaxNode)
          nr0 << r2
          if r2.success?
            r0 = r2
            r2.update_nested_results(nr0)
          else
            self.index = i0
            r0 = ParseFailure.new(i0, nr0)
          end
        end
        return r0
      end
      def _nt_space
        s0, nr0, i0 = [], [], index
        loop do
          r1 = parse_char_class(/[ \t\n\r]/, ' \t\n\r', SyntaxNode)
          nr0 << r1
          if r1.success?
            s0 << r1
          else
            break
          end
        end
        if s0.empty?
          self.index = i0
          r0 = ParseFailure.new(i0, nr0)
        else
          r0 = SyntaxNode.new(input, i0...index, s0, nr0)
        end
        return r0
      end
    end
  end
end
