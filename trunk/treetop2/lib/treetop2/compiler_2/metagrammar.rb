module Treetop2
  module Compiler2
    class Metagrammar < ::Treetop2::Parser::CompiledParser
      include ::Treetop2::Parser
  
      def root
        _nt_treetop_file
      end
  
      def _nt_treetop_file
        start_index = index
        cached = node_cache[:treetop_file][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        s0, nr0, i0 = [], [], index
        loop do
          i1, nr1 = index, []
          r2 = _nt_grammar
          nr1 << r2
          if r2.success?
            r1 = r2
            r2.update_nested_results(nr1)
          else
            r3 = _nt_arbitrary_character
            nr1 << r3
            if r3.success?
              r1 = r3
              r3.update_nested_results(nr1)
            else
              self.index = i1
              r1 = ParseFailure.new(input, i1, nr1)
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
    
        node_cache[:treetop_file][start_index] = r0
    
        return r0
      end
  
      module ArbitraryCharacter0
        def compile
          text_value
        end
      end
  
      def _nt_arbitrary_character
        start_index = index
        cached = node_cache[:arbitrary_character][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        r0 = parse_anything(SyntaxNode, ArbitraryCharacter0)
    
        node_cache[:arbitrary_character][start_index] = r0
    
        return r0
      end
  
      module Grammar0
        def space
          elements[1]
        end
    
        def grammar_name
          elements[2]
        end
    
        def space
          elements[3]
        end
    
        def parsing_rule_sequence
          elements[4]
        end
    
      end
  
      def _nt_grammar
        start_index = index
        cached = node_cache[:grammar][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, s0, nr0 = index, [], []
        r1 = parse_terminal('grammar', SyntaxNode)
        s0 << r1
        if r1.success?
          r2 = _nt_space
          s0 << r2
          if r2.success?
            r3 = _nt_grammar_name
            s0 << r3
            if r3.success?
              r4 = _nt_space
              s0 << r4
              if r4.success?
                r5 = _nt_parsing_rule_sequence
                s0 << r5
                if r5.success?
                  r7 = _nt_space
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
          r0.extend(Grammar0)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:grammar][start_index] = r0
    
        return r0
      end
  
      module GrammarName0
      end
  
      def _nt_grammar_name
        start_index = index
        cached = node_cache[:grammar_name][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, s0, nr0 = index, [], []
        r1 = parse_char_class(/[A-Z]/, 'A-Z', SyntaxNode)
        s0 << r1
        if r1.success?
          s2, nr2, i2 = [], [], index
          loop do
            r3 = _nt_alphanumeric_char
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
          r0.extend(GrammarName0)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:grammar_name][start_index] = r0
    
        return r0
      end
  
      module ParsingRuleSequence0
        def space
          elements[0]
        end
    
        def parsing_rule
          elements[1]
        end
      end
  
      module ParsingRuleSequence1
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
  
      module ParsingRuleSequence2
        def parsing_rule
          elements[0]
        end
    
      end
  
      def _nt_parsing_rule_sequence
        start_index = index
        cached = node_cache[:parsing_rule_sequence][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, nr0 = index, []
        i1, s1, nr1 = index, [], []
        r2 = _nt_parsing_rule
        s1 << r2
        if r2.success?
          s3, nr3, i3 = [], [], index
          loop do
            i4, s4, nr4 = index, [], []
            r5 = _nt_space
            s4 << r5
            if r5.success?
              r6 = _nt_parsing_rule
              s4 << r6
            end
            if s4.last.success?
              r4 = (SyntaxNode).new(input, i4...index, s4)
              r4.extend(ParsingRuleSequence0)
            else
              self.index = i4
              r4 = ParseFailure.new(input, i4, s4)
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
          r1.extend(ParsingRuleSequence2)
          r1.extend(ParsingRuleSequence1)
        else
          self.index = i1
          r1 = ParseFailure.new(input, i1, s1)
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
            r0 = ParseFailure.new(input, i0, nr0)
          end
        end
    
        node_cache[:parsing_rule_sequence][start_index] = r0
    
        return r0
      end
  
      module ParsingRule0
        def space
          elements[1]
        end
    
        def nonterminal
          elements[2]
        end
    
        def space
          elements[3]
        end
    
        def parsing_expression
          elements[4]
        end
    
        def space
          elements[5]
        end
    
      end
  
      def _nt_parsing_rule
        start_index = index
        cached = node_cache[:parsing_rule][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, s0, nr0 = index, [], []
        r1 = parse_terminal('rule', SyntaxNode)
        s0 << r1
        if r1.success?
          r2 = _nt_space
          s0 << r2
          if r2.success?
            r3 = _nt_nonterminal
            s0 << r3
            if r3.success?
              r4 = _nt_space
              s0 << r4
              if r4.success?
                r5 = _nt_parsing_expression
                s0 << r5
                if r5.success?
                  r6 = _nt_space
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
          r0.extend(ParsingRule0)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:parsing_rule][start_index] = r0
    
        return r0
      end
  
      def _nt_parsing_expression
        start_index = index
        cached = node_cache[:parsing_expression][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, nr0 = index, []
        r1 = _nt_choice
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r2 = _nt_sequence
          nr0 << r2
          if r2.success?
            r0 = r2
            r2.update_nested_results(nr0)
          else
            r3 = _nt_primary
            nr0 << r3
            if r3.success?
              r0 = r3
              r3.update_nested_results(nr0)
            else
              self.index = i0
              r0 = ParseFailure.new(input, i0, nr0)
            end
          end
        end
    
        node_cache[:parsing_expression][start_index] = r0
    
        return r0
      end
  
      module Choice0
        def alternative
          elements[3]
        end
      end
  
      module Choice1
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
  
      module Choice2
        def alternative
          elements[0]
        end
    
      end
  
      def _nt_choice
        start_index = index
        cached = node_cache[:choice][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, s0, nr0 = index, [], []
        r1 = _nt_alternative
        s0 << r1
        if r1.success?
          s2, nr2, i2 = [], [], index
          loop do
            i3, s3, nr3 = index, [], []
            r5 = _nt_space
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
                r8 = _nt_space
                if r8.success?
                  r7 = r8
                else
                  r7 = SyntaxNode.new(input, index...index, r8.nested_failures)
                end
                s3 << r7
                if r7.success?
                  r9 = _nt_alternative
                  s3 << r9
                end
              end
            end
            if s3.last.success?
              r3 = (SyntaxNode).new(input, i3...index, s3)
              r3.extend(Choice0)
            else
              self.index = i3
              r3 = ParseFailure.new(input, i3, s3)
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
            r2 = ParseFailure.new(input, i2, nr2)
          else
            r2 = SyntaxNode.new(input, i2...index, s2, nr2)
          end
          s0 << r2
        end
        if s0.last.success?
          r0 = (Choice).new(input, i0...index, s0)
          r0.extend(Choice2)
          r0.extend(Choice1)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:choice][start_index] = r0
    
        return r0
      end
  
      module Sequence0
        def space
          elements[0]
        end
    
        def labeled_sequence_primary
          elements[1]
        end
      end
  
      module Sequence1
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
          (sequence_elements.map {|elt| elt.inline_modules}).flatten +
          node_class_declarations.inline_modules +
          [sequence_element_accessor_module]
        end
    
        def inline_module_name
          node_class_declarations.inline_module_name
        end
      end
  
      module Sequence2
        def labeled_sequence_primary
          elements[0]
        end
    
        def node_class_declarations
          elements[2]
        end
      end
  
      def _nt_sequence
        start_index = index
        cached = node_cache[:sequence][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, s0, nr0 = index, [], []
        r1 = _nt_labeled_sequence_primary
        s0 << r1
        if r1.success?
          s2, nr2, i2 = [], [], index
          loop do
            i3, s3, nr3 = index, [], []
            r4 = _nt_space
            s3 << r4
            if r4.success?
              r5 = _nt_labeled_sequence_primary
              s3 << r5
            end
            if s3.last.success?
              r3 = (SyntaxNode).new(input, i3...index, s3)
              r3.extend(Sequence0)
            else
              self.index = i3
              r3 = ParseFailure.new(input, i3, s3)
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
            r2 = ParseFailure.new(input, i2, nr2)
          else
            r2 = SyntaxNode.new(input, i2...index, s2, nr2)
          end
          s0 << r2
          if r2.success?
            r6 = _nt_node_class_declarations
            s0 << r6
          end
        end
        if s0.last.success?
          r0 = (Sequence).new(input, i0...index, s0)
          r0.extend(Sequence2)
          r0.extend(Sequence1)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:sequence][start_index] = r0
    
        return r0
      end
  
      def _nt_alternative
        start_index = index
        cached = node_cache[:alternative][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, nr0 = index, []
        r1 = _nt_sequence
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r2 = _nt_primary
          nr0 << r2
          if r2.success?
            r0 = r2
            r2.update_nested_results(nr0)
          else
            self.index = i0
            r0 = ParseFailure.new(input, i0, nr0)
          end
        end
    
        node_cache[:alternative][start_index] = r0
    
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
        def prefix
          elements[0]
        end
    
        def atomic
          elements[1]
        end
      end
  
      module Primary2
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
  
      module Primary3
        def atomic
          elements[0]
        end
    
        def suffix
          elements[1]
        end
    
        def node_class_declarations
          elements[2]
        end
      end
  
      module Primary4
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
  
      module Primary5
        def atomic
          elements[0]
        end
    
        def node_class_declarations
          elements[1]
        end
      end
  
      def _nt_primary
        start_index = index
        cached = node_cache[:primary][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, nr0 = index, []
        i1, s1, nr1 = index, [], []
        r2 = _nt_prefix
        s1 << r2
        if r2.success?
          r3 = _nt_atomic
          s1 << r3
        end
        if s1.last.success?
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(Primary1)
          r1.extend(Primary0)
        else
          self.index = i1
          r1 = ParseFailure.new(input, i1, s1)
        end
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          i4, s4, nr4 = index, [], []
          r5 = _nt_atomic
          s4 << r5
          if r5.success?
            r6 = _nt_suffix
            s4 << r6
            if r6.success?
              r7 = _nt_node_class_declarations
              s4 << r7
            end
          end
          if s4.last.success?
            r4 = (SyntaxNode).new(input, i4...index, s4)
            r4.extend(Primary3)
            r4.extend(Primary2)
          else
            self.index = i4
            r4 = ParseFailure.new(input, i4, s4)
          end
          nr0 << r4
          if r4.success?
            r0 = r4
            r4.update_nested_results(nr0)
          else
            i8, s8, nr8 = index, [], []
            r9 = _nt_atomic
            s8 << r9
            if r9.success?
              r10 = _nt_node_class_declarations
              s8 << r10
            end
            if s8.last.success?
              r8 = (SyntaxNode).new(input, i8...index, s8)
              r8.extend(Primary5)
              r8.extend(Primary4)
            else
              self.index = i8
              r8 = ParseFailure.new(input, i8, s8)
            end
            nr0 << r8
            if r8.success?
              r0 = r8
              r8.update_nested_results(nr0)
            else
              self.index = i0
              r0 = ParseFailure.new(input, i0, nr0)
            end
          end
        end
    
        node_cache[:primary][start_index] = r0
    
        return r0
      end
  
      module LabeledSequencePrimary0
        def compile(lexical_address, builder)
          sequence_primary.compile(lexical_address, builder)
        end
    
        def inline_modules
          sequence_primary.inline_modules
        end
    
        def label_name
          if label.name
            label.name
          elsif sequence_primary.instance_of?(Nonterminal)
            sequence_primary.text_value
          else
            nil
          end
        end
      end
  
      module LabeledSequencePrimary1
        def label
          elements[0]
        end
    
        def sequence_primary
          elements[1]
        end
      end
  
      def _nt_labeled_sequence_primary
        start_index = index
        cached = node_cache[:labeled_sequence_primary][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, s0, nr0 = index, [], []
        r1 = _nt_label
        s0 << r1
        if r1.success?
          r2 = _nt_sequence_primary
          s0 << r2
        end
        if s0.last.success?
          r0 = (SyntaxNode).new(input, i0...index, s0)
          r0.extend(LabeledSequencePrimary1)
          r0.extend(LabeledSequencePrimary0)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:labeled_sequence_primary][start_index] = r0
    
        return r0
      end
  
      module Label0
        def alpha_char
          elements[0]
        end
    
      end
  
      module Label1
        def name
          elements[0].text_value
        end
      end
  
      module Label2
      end
  
      module Label3
        def name
          nil
        end
      end
  
      def _nt_label
        start_index = index
        cached = node_cache[:label][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, nr0 = index, []
        i1, s1, nr1 = index, [], []
        i2, s2, nr2 = index, [], []
        r3 = _nt_alpha_char
        s2 << r3
        if r3.success?
          s4, nr4, i4 = [], [], index
          loop do
            r5 = _nt_alphanumeric_char
            nr4 << r5
            if r5.success?
              s4 << r5
            else
              break
            end
          end
          r4 = SyntaxNode.new(input, i4...index, s4, nr4)
          s2 << r4
        end
        if s2.last.success?
          r2 = (SyntaxNode).new(input, i2...index, s2)
          r2.extend(Label0)
        else
          self.index = i2
          r2 = ParseFailure.new(input, i2, s2)
        end
        s1 << r2
        if r2.success?
          r6 = parse_terminal(':', SyntaxNode)
          s1 << r6
        end
        if s1.last.success?
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(Label2)
          r1.extend(Label1)
        else
          self.index = i1
          r1 = ParseFailure.new(input, i1, s1)
        end
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r7 = parse_terminal('', SyntaxNode, Label3)
          nr0 << r7
          if r7.success?
            r0 = r7
            r7.update_nested_results(nr0)
          else
            self.index = i0
            r0 = ParseFailure.new(input, i0, nr0)
          end
        end
    
        node_cache[:label][start_index] = r0
    
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
        def prefix
          elements[0]
        end
    
        def atomic
          elements[1]
        end
      end
  
      module SequencePrimary2
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
  
      module SequencePrimary3
        def atomic
          elements[0]
        end
    
        def suffix
          elements[1]
        end
      end
  
      def _nt_sequence_primary
        start_index = index
        cached = node_cache[:sequence_primary][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, nr0 = index, []
        i1, s1, nr1 = index, [], []
        r2 = _nt_prefix
        s1 << r2
        if r2.success?
          r3 = _nt_atomic
          s1 << r3
        end
        if s1.last.success?
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(SequencePrimary1)
          r1.extend(SequencePrimary0)
        else
          self.index = i1
          r1 = ParseFailure.new(input, i1, s1)
        end
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          i4, s4, nr4 = index, [], []
          r5 = _nt_atomic
          s4 << r5
          if r5.success?
            r6 = _nt_suffix
            s4 << r6
          end
          if s4.last.success?
            r4 = (SyntaxNode).new(input, i4...index, s4)
            r4.extend(SequencePrimary3)
            r4.extend(SequencePrimary2)
          else
            self.index = i4
            r4 = ParseFailure.new(input, i4, s4)
          end
          nr0 << r4
          if r4.success?
            r0 = r4
            r4.update_nested_results(nr0)
          else
            r7 = _nt_atomic
            nr0 << r7
            if r7.success?
              r0 = r7
              r7.update_nested_results(nr0)
            else
              self.index = i0
              r0 = ParseFailure.new(input, i0, nr0)
            end
          end
        end
    
        node_cache[:sequence_primary][start_index] = r0
    
        return r0
      end
  
      def _nt_suffix
        start_index = index
        cached = node_cache[:suffix][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, nr0 = index, []
        r1 = _nt_repetition_suffix
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r2 = _nt_optional_suffix
          nr0 << r2
          if r2.success?
            r0 = r2
            r2.update_nested_results(nr0)
          else
            self.index = i0
            r0 = ParseFailure.new(input, i0, nr0)
          end
        end
    
        node_cache[:suffix][start_index] = r0
    
        return r0
      end
  
      def _nt_optional_suffix
        start_index = index
        cached = node_cache[:optional_suffix][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        r0 = parse_terminal('?', Optional)
    
        node_cache[:optional_suffix][start_index] = r0
    
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
  
      module NodeClassDeclarations1
        def node_class_expression
          elements[0]
        end
    
        def trailing_inline_module
          elements[1]
        end
      end
  
      def _nt_node_class_declarations
        start_index = index
        cached = node_cache[:node_class_declarations][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, s0, nr0 = index, [], []
        r1 = _nt_node_class_expression
        s0 << r1
        if r1.success?
          r2 = _nt_trailing_inline_module
          s0 << r2
        end
        if s0.last.success?
          r0 = (SyntaxNode).new(input, i0...index, s0)
          r0.extend(NodeClassDeclarations1)
          r0.extend(NodeClassDeclarations0)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:node_class_declarations][start_index] = r0
    
        return r0
      end
  
      def _nt_repetition_suffix
        start_index = index
        cached = node_cache[:repetition_suffix][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
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
            r0 = ParseFailure.new(input, i0, nr0)
          end
        end
    
        node_cache[:repetition_suffix][start_index] = r0
    
        return r0
      end
  
      def _nt_prefix
        start_index = index
        cached = node_cache[:prefix][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
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
            r0 = ParseFailure.new(input, i0, nr0)
          end
        end
    
        node_cache[:prefix][start_index] = r0
    
        return r0
      end
  
      def _nt_atomic
        start_index = index
        cached = node_cache[:atomic][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, nr0 = index, []
        r1 = _nt_terminal
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r2 = _nt_nonterminal
          nr0 << r2
          if r2.success?
            r0 = r2
            r2.update_nested_results(nr0)
          else
            r3 = _nt_parenthesized_expression
            nr0 << r3
            if r3.success?
              r0 = r3
              r3.update_nested_results(nr0)
            else
              self.index = i0
              r0 = ParseFailure.new(input, i0, nr0)
            end
          end
        end
    
        node_cache[:atomic][start_index] = r0
    
        return r0
      end
  
      module ParenthesizedExpression0
        def inline_modules
          parsing_expression.inline_modules
        end
      end
  
      module ParenthesizedExpression1
        def parsing_expression
          elements[2]
        end
    
      end
  
      def _nt_parenthesized_expression
        start_index = index
        cached = node_cache[:parenthesized_expression][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, s0, nr0 = index, [], []
        r1 = parse_terminal('(', SyntaxNode)
        s0 << r1
        if r1.success?
          r3 = _nt_space
          if r3.success?
            r2 = r3
          else
            r2 = SyntaxNode.new(input, index...index, r3.nested_failures)
          end
          s0 << r2
          if r2.success?
            r4 = _nt_parsing_expression
            s0 << r4
            if r4.success?
              r6 = _nt_space
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
          r0.extend(ParenthesizedExpression1)
          r0.extend(ParenthesizedExpression0)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:parenthesized_expression][start_index] = r0
    
        return r0
      end
  
      module Nonterminal0
        def alpha_char
          elements[0]
        end
    
      end
  
      module Nonterminal1
      end
  
      def _nt_nonterminal
        start_index = index
        cached = node_cache[:nonterminal][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, s0, nr0 = index, [], []
        i1 = index
        r2 = _nt_keyword_inside_grammar
        if r2.success?
          r1 = ParseFailure.new(input, i1, r2.nested_failures)
        else
          self.index = i1
          r1 = SyntaxNode.new(input, index...index, r2.nested_failures)
        end
        s0 << r1
        if r1.success?
          i3, s3, nr3 = index, [], []
          r4 = _nt_alpha_char
          s3 << r4
          if r4.success?
            s5, nr5, i5 = [], [], index
            loop do
              r6 = _nt_alphanumeric_char
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
            r3.extend(Nonterminal0)
          else
            self.index = i3
            r3 = ParseFailure.new(input, i3, s3)
          end
          s0 << r3
        end
        if s0.last.success?
          r0 = (Nonterminal).new(input, i0...index, s0)
          r0.extend(Nonterminal1)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:nonterminal][start_index] = r0
    
        return r0
      end
  
      def _nt_terminal
        start_index = index
        cached = node_cache[:terminal][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, nr0 = index, []
        r1 = _nt_single_quoted_string
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r2 = _nt_double_quoted_string
          nr0 << r2
          if r2.success?
            r0 = r2
            r2.update_nested_results(nr0)
          else
            r3 = _nt_character_class
            nr0 << r3
            if r3.success?
              r0 = r3
              r3.update_nested_results(nr0)
            else
              r4 = _nt_anything_symbol
              nr0 << r4
              if r4.success?
                r0 = r4
                r4.update_nested_results(nr0)
              else
                self.index = i0
                r0 = ParseFailure.new(input, i0, nr0)
              end
            end
          end
        end
    
        node_cache[:terminal][start_index] = r0
    
        return r0
      end
  
      module DoubleQuotedString0
      end
  
      module DoubleQuotedString1
      end
  
      def _nt_double_quoted_string
        start_index = index
        cached = node_cache[:double_quoted_string][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
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
              r4 = ParseFailure.new(input, i4, r5.nested_failures)
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
                    r6 = ParseFailure.new(input, i6, nr6)
                  end
                end
              end
              s3 << r6
            end
            if s3.last.success?
              r3 = (SyntaxNode).new(input, i3...index, s3)
              r3.extend(DoubleQuotedString0)
            else
              self.index = i3
              r3 = ParseFailure.new(input, i3, s3)
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
          r0.extend(DoubleQuotedString1)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:double_quoted_string][start_index] = r0
    
        return r0
      end
  
      module SingleQuotedString0
      end
  
      module SingleQuotedString1
      end
  
      def _nt_single_quoted_string
        start_index = index
        cached = node_cache[:single_quoted_string][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
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
              r4 = ParseFailure.new(input, i4, r5.nested_failures)
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
                    r6 = ParseFailure.new(input, i6, nr6)
                  end
                end
              end
              s3 << r6
            end
            if s3.last.success?
              r3 = (SyntaxNode).new(input, i3...index, s3)
              r3.extend(SingleQuotedString0)
            else
              self.index = i3
              r3 = ParseFailure.new(input, i3, s3)
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
          r0.extend(SingleQuotedString1)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:single_quoted_string][start_index] = r0
    
        return r0
      end
  
      module CharacterClass0
      end
  
      module CharacterClass1
      end
  
      def _nt_character_class
        start_index = index
        cached = node_cache[:character_class][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
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
              r4 = ParseFailure.new(input, i4, r5.nested_failures)
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
                  r6 = ParseFailure.new(input, i6, nr6)
                end
              end
              s3 << r6
            end
            if s3.last.success?
              r3 = (SyntaxNode).new(input, i3...index, s3)
              r3.extend(CharacterClass0)
            else
              self.index = i3
              r3 = ParseFailure.new(input, i3, s3)
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
            r2 = ParseFailure.new(input, i2, nr2)
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
          r0.extend(CharacterClass1)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:character_class][start_index] = r0
    
        return r0
      end
  
      def _nt_anything_symbol
        start_index = index
        cached = node_cache[:anything_symbol][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        r0 = parse_terminal('.', AnythingSymbol)
    
        node_cache[:anything_symbol][start_index] = r0
    
        return r0
      end
  
      module NodeClassExpression0
      end
  
      module NodeClassExpression1
        def node_class
          elements[2].text_value
        end
      end
  
      module NodeClassExpression2
        def space
          elements[0]
        end
    
      end
  
      module NodeClassExpression3
        def node_class
          'SyntaxNode'
        end
      end
  
      def _nt_node_class_expression
        start_index = index
        cached = node_cache[:node_class_expression][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, nr0 = index, []
        i1, s1, nr1 = index, [], []
        r2 = _nt_space
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
                r6 = ParseFailure.new(input, i6, r7.nested_failures)
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
                r5.extend(NodeClassExpression0)
              else
                self.index = i5
                r5 = ParseFailure.new(input, i5, s5)
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
              r4 = ParseFailure.new(input, i4, nr4)
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
          r1.extend(NodeClassExpression2)
          r1.extend(NodeClassExpression1)
        else
          self.index = i1
          r1 = ParseFailure.new(input, i1, s1)
        end
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r10 = parse_terminal('', SyntaxNode, NodeClassExpression3)
          nr0 << r10
          if r10.success?
            r0 = r10
            r10.update_nested_results(nr0)
          else
            self.index = i0
            r0 = ParseFailure.new(input, i0, nr0)
          end
        end
    
        node_cache[:node_class_expression][start_index] = r0
    
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
        def space
          elements[0]
        end
    
        def inline_module
          elements[1]
        end
      end
  
      module TrailingInlineModule2
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
        start_index = index
        cached = node_cache[:trailing_inline_module][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, nr0 = index, []
        i1, s1, nr1 = index, [], []
        r2 = _nt_space
        s1 << r2
        if r2.success?
          r3 = _nt_inline_module
          s1 << r3
        end
        if s1.last.success?
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(TrailingInlineModule1)
          r1.extend(TrailingInlineModule0)
        else
          self.index = i1
          r1 = ParseFailure.new(input, i1, s1)
        end
        nr0 << r1
        if r1.success?
          r0 = r1
          r1.update_nested_results(nr0)
        else
          r4 = parse_terminal('', SyntaxNode, TrailingInlineModule2)
          nr0 << r4
          if r4.success?
            r0 = r4
            r4.update_nested_results(nr0)
          else
            self.index = i0
            r0 = ParseFailure.new(input, i0, nr0)
          end
        end
    
        node_cache[:trailing_inline_module][start_index] = r0
    
        return r0
      end
  
      module InlineModule0
      end
  
      module InlineModule1
      end
  
      def _nt_inline_module
        start_index = index
        cached = node_cache[:inline_module][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, s0, nr0 = index, [], []
        r1 = parse_terminal('{', SyntaxNode)
        s0 << r1
        if r1.success?
          s2, nr2, i2 = [], [], index
          loop do
            i3, nr3 = index, []
            r4 = _nt_inline_module
            nr3 << r4
            if r4.success?
              r3 = r4
              r4.update_nested_results(nr3)
            else
              i5, s5, nr5 = index, [], []
              i6 = index
              r7 = parse_char_class(/[{}]/, '{}', SyntaxNode)
              if r7.success?
                r6 = ParseFailure.new(input, i6, r7.nested_failures)
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
                r5.extend(InlineModule0)
              else
                self.index = i5
                r5 = ParseFailure.new(input, i5, s5)
              end
              nr3 << r5
              if r5.success?
                r3 = r5
                r5.update_nested_results(nr3)
              else
                self.index = i3
                r3 = ParseFailure.new(input, i3, nr3)
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
          r0.extend(InlineModule1)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:inline_module][start_index] = r0
    
        return r0
      end
  
      module KeywordInsideGrammar0
      end
  
      def _nt_keyword_inside_grammar
        start_index = index
        cached = node_cache[:keyword_inside_grammar][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
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
            r1 = ParseFailure.new(input, i1, nr1)
          end
        end
        s0 << r1
        if r1.success?
          i4 = index
          r5 = _nt_non_space_char
          if r5.success?
            r4 = ParseFailure.new(input, i4, r5.nested_failures)
          else
            self.index = i4
            r4 = SyntaxNode.new(input, index...index, r5.nested_failures)
          end
          s0 << r4
        end
        if s0.last.success?
          r0 = (SyntaxNode).new(input, i0...index, s0)
          r0.extend(KeywordInsideGrammar0)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:keyword_inside_grammar][start_index] = r0
    
        return r0
      end
  
      module NonSpaceChar0
      end
  
      def _nt_non_space_char
        start_index = index
        cached = node_cache[:non_space_char][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, s0, nr0 = index, [], []
        i1 = index
        r2 = _nt_space
        if r2.success?
          r1 = ParseFailure.new(input, i1, r2.nested_failures)
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
          r0.extend(NonSpaceChar0)
        else
          self.index = i0
          r0 = ParseFailure.new(input, i0, s0)
        end
    
        node_cache[:non_space_char][start_index] = r0
    
        return r0
      end
  
      def _nt_alpha_char
        start_index = index
        cached = node_cache[:alpha_char][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        r0 = parse_char_class(/[A-Za-z_]/, 'A-Za-z_', SyntaxNode)
    
        node_cache[:alpha_char][start_index] = r0
    
        return r0
      end
  
      def _nt_alphanumeric_char
        start_index = index
        cached = node_cache[:alphanumeric_char][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
        i0, nr0 = index, []
        r1 = _nt_alpha_char
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
            r0 = ParseFailure.new(input, i0, nr0)
          end
        end
    
        node_cache[:alphanumeric_char][start_index] = r0
    
        return r0
      end
  
      def _nt_space
        start_index = index
        cached = node_cache[:space][index]
        if cached
          @index = cached.interval.end
          return cached
        end
    
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
          r0 = ParseFailure.new(input, i0, nr0)
        else
          r0 = SyntaxNode.new(input, i0...index, s0, nr0)
        end
    
        node_cache[:space][start_index] = r0
    
        return r0
      end
    end
  end
end