module Treetop
  module Compiler
    module Metagrammar
      include Treetop::Runtime

      def root
        @root || :treetop_file
      end

      module TreetopFile0
        def prefix
          elements[0]
        end

        def module_or_grammar
          elements[1]
        end

        def suffix
          elements[2]
        end
      end

      module TreetopFile1
        def compile
          prefix.text_value + module_or_grammar.compile + suffix.text_value
        end
      end

      def _nt_treetop_file
        start_index = index
        if node_cache[:treetop_file].has_key?(index)
          cached = node_cache[:treetop_file][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        r2 = _nt_space
        if r2
          r1 = r2
        else
          r1 = SyntaxNode.new(input, index...index)
        end
        s0 << r1
        if r1
          i3 = index
          r4 = _nt_module_declaration
          if r4
            r3 = r4
          else
            r5 = _nt_grammar
            if r5
              r3 = r5
            else
              self.index = i3
              r3 = nil
            end
          end
          s0 << r3
          if r3
            r7 = _nt_space
            if r7
              r6 = r7
            else
              r6 = SyntaxNode.new(input, index...index)
            end
            s0 << r6
          end
        end
        if s0.last
          r0 = (SyntaxNode).new(input, i0...index, s0)
          r0.extend(TreetopFile0)
          r0.extend(TreetopFile1)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:treetop_file][start_index] = r0

        return r0
      end

      module ModuleDeclaration0
        def space
          elements[1]
        end

        def space
          elements[4]
        end
      end

      module ModuleDeclaration1
        def space
          elements[0]
        end

      end

      module ModuleDeclaration2
        def prefix
          elements[0]
        end

        def module_contents
          elements[1]
        end

        def suffix
          elements[2]
        end
      end

      module ModuleDeclaration3
        def compile
          prefix.text_value + module_contents.compile + suffix.text_value
        end
      end

      def _nt_module_declaration
        start_index = index
        if node_cache[:module_declaration].has_key?(index)
          cached = node_cache[:module_declaration][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        i1, s1 = index, []
        if input.index('module', index) == index
          r2 = (SyntaxNode).new(input, index...(index + 6))
          @index += 6
        else
          terminal_parse_failure('module')
          r2 = nil
        end
        s1 << r2
        if r2
          r3 = _nt_space
          s1 << r3
          if r3
            if input.index(Regexp.new('[A-Z]'), index) == index
              r4 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              r4 = nil
            end
            s1 << r4
            if r4
              s5, i5 = [], index
              loop do
                r6 = _nt_alphanumeric_char
                if r6
                  s5 << r6
                else
                  break
                end
              end
              r5 = SyntaxNode.new(input, i5...index, s5)
              s1 << r5
              if r5
                r7 = _nt_space
                s1 << r7
              end
            end
          end
        end
        if s1.last
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(ModuleDeclaration0)
        else
          self.index = i1
          r1 = nil
        end
        s0 << r1
        if r1
          i8 = index
          r9 = _nt_module_declaration
          if r9
            r8 = r9
          else
            r10 = _nt_grammar
            if r10
              r8 = r10
            else
              self.index = i8
              r8 = nil
            end
          end
          s0 << r8
          if r8
            i11, s11 = index, []
            r12 = _nt_space
            s11 << r12
            if r12
              if input.index('end', index) == index
                r13 = (SyntaxNode).new(input, index...(index + 3))
                @index += 3
              else
                terminal_parse_failure('end')
                r13 = nil
              end
              s11 << r13
            end
            if s11.last
              r11 = (SyntaxNode).new(input, i11...index, s11)
              r11.extend(ModuleDeclaration1)
            else
              self.index = i11
              r11 = nil
            end
            s0 << r11
          end
        end
        if s0.last
          r0 = (SyntaxNode).new(input, i0...index, s0)
          r0.extend(ModuleDeclaration2)
          r0.extend(ModuleDeclaration3)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:module_declaration][start_index] = r0

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

        def declaration_sequence
          elements[4]
        end

      end

      def _nt_grammar
        start_index = index
        if node_cache[:grammar].has_key?(index)
          cached = node_cache[:grammar][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        if input.index('grammar', index) == index
          r1 = (SyntaxNode).new(input, index...(index + 7))
          @index += 7
        else
          terminal_parse_failure('grammar')
          r1 = nil
        end
        s0 << r1
        if r1
          r2 = _nt_space
          s0 << r2
          if r2
            r3 = _nt_grammar_name
            s0 << r3
            if r3
              r4 = _nt_space
              s0 << r4
              if r4
                r5 = _nt_declaration_sequence
                s0 << r5
                if r5
                  r7 = _nt_space
                  if r7
                    r6 = r7
                  else
                    r6 = SyntaxNode.new(input, index...index)
                  end
                  s0 << r6
                  if r6
                    if input.index('end', index) == index
                      r8 = (SyntaxNode).new(input, index...(index + 3))
                      @index += 3
                    else
                      terminal_parse_failure('end')
                      r8 = nil
                    end
                    s0 << r8
                  end
                end
              end
            end
          end
        end
        if s0.last
          r0 = (Grammar).new(input, i0...index, s0)
          r0.extend(Grammar0)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:grammar][start_index] = r0

        return r0
      end

      module GrammarName0
      end

      def _nt_grammar_name
        start_index = index
        if node_cache[:grammar_name].has_key?(index)
          cached = node_cache[:grammar_name][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        if input.index(Regexp.new('[A-Z]'), index) == index
          r1 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r1 = nil
        end
        s0 << r1
        if r1
          s2, i2 = [], index
          loop do
            r3 = _nt_alphanumeric_char
            if r3
              s2 << r3
            else
              break
            end
          end
          r2 = SyntaxNode.new(input, i2...index, s2)
          s0 << r2
        end
        if s0.last
          r0 = (SyntaxNode).new(input, i0...index, s0)
          r0.extend(GrammarName0)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:grammar_name][start_index] = r0

        return r0
      end

      module DeclarationSequence0
        def space
          elements[0]
        end

        def declaration
          elements[1]
        end
      end

      module DeclarationSequence1
        def head
          elements[0]
        end

        def tail
          elements[1]
        end
      end

      module DeclarationSequence2
        def declarations
          [head] + tail
        end
    
        def tail
          super.elements.map { |elt| elt.declaration }
        end
      end

      module DeclarationSequence3
        def compile(builder)
        end
      end

      def _nt_declaration_sequence
        start_index = index
        if node_cache[:declaration_sequence].has_key?(index)
          cached = node_cache[:declaration_sequence][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        i1, s1 = index, []
        r2 = _nt_declaration
        s1 << r2
        if r2
          s3, i3 = [], index
          loop do
            i4, s4 = index, []
            r5 = _nt_space
            s4 << r5
            if r5
              r6 = _nt_declaration
              s4 << r6
            end
            if s4.last
              r4 = (SyntaxNode).new(input, i4...index, s4)
              r4.extend(DeclarationSequence0)
            else
              self.index = i4
              r4 = nil
            end
            if r4
              s3 << r4
            else
              break
            end
          end
          r3 = SyntaxNode.new(input, i3...index, s3)
          s1 << r3
        end
        if s1.last
          r1 = (DeclarationSequence).new(input, i1...index, s1)
          r1.extend(DeclarationSequence1)
          r1.extend(DeclarationSequence2)
        else
          self.index = i1
          r1 = nil
        end
        if r1
          r0 = r1
        else
          if input.index('', index) == index
            r7 = (SyntaxNode).new(input, index...(index + 0))
            r7.extend(DeclarationSequence3)
            @index += 0
          else
            terminal_parse_failure('')
            r7 = nil
          end
          if r7
            r0 = r7
          else
            self.index = i0
            r0 = nil
          end
        end

        node_cache[:declaration_sequence][start_index] = r0

        return r0
      end

      def _nt_declaration
        start_index = index
        if node_cache[:declaration].has_key?(index)
          cached = node_cache[:declaration][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        r1 = _nt_parsing_rule
        if r1
          r0 = r1
        else
          r2 = _nt_include_declaration
          if r2
            r0 = r2
          else
            self.index = i0
            r0 = nil
          end
        end

        node_cache[:declaration][start_index] = r0

        return r0
      end

      module IncludeDeclaration0
        def space
          elements[1]
        end

      end

      module IncludeDeclaration1
        def compile(builder)
          builder << text_value
        end
      end

      def _nt_include_declaration
        start_index = index
        if node_cache[:include_declaration].has_key?(index)
          cached = node_cache[:include_declaration][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        if input.index('include', index) == index
          r1 = (SyntaxNode).new(input, index...(index + 7))
          @index += 7
        else
          terminal_parse_failure('include')
          r1 = nil
        end
        s0 << r1
        if r1
          r2 = _nt_space
          s0 << r2
          if r2
            if input.index(Regexp.new('[A-Z]'), index) == index
              r3 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              r3 = nil
            end
            s0 << r3
            if r3
              s4, i4 = [], index
              loop do
                i5 = index
                r6 = _nt_alphanumeric_char
                if r6
                  r5 = r6
                else
                  if input.index('::', index) == index
                    r7 = (SyntaxNode).new(input, index...(index + 2))
                    @index += 2
                  else
                    terminal_parse_failure('::')
                    r7 = nil
                  end
                  if r7
                    r5 = r7
                  else
                    self.index = i5
                    r5 = nil
                  end
                end
                if r5
                  s4 << r5
                else
                  break
                end
              end
              r4 = SyntaxNode.new(input, i4...index, s4)
              s0 << r4
            end
          end
        end
        if s0.last
          r0 = (SyntaxNode).new(input, i0...index, s0)
          r0.extend(IncludeDeclaration0)
          r0.extend(IncludeDeclaration1)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:include_declaration][start_index] = r0

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
        if node_cache[:parsing_rule].has_key?(index)
          cached = node_cache[:parsing_rule][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        if input.index('rule', index) == index
          r1 = (SyntaxNode).new(input, index...(index + 4))
          @index += 4
        else
          terminal_parse_failure('rule')
          r1 = nil
        end
        s0 << r1
        if r1
          r2 = _nt_space
          s0 << r2
          if r2
            r3 = _nt_nonterminal
            s0 << r3
            if r3
              r4 = _nt_space
              s0 << r4
              if r4
                r5 = _nt_parsing_expression
                s0 << r5
                if r5
                  r6 = _nt_space
                  s0 << r6
                  if r6
                    if input.index('end', index) == index
                      r7 = (SyntaxNode).new(input, index...(index + 3))
                      @index += 3
                    else
                      terminal_parse_failure('end')
                      r7 = nil
                    end
                    s0 << r7
                  end
                end
              end
            end
          end
        end
        if s0.last
          r0 = (ParsingRule).new(input, i0...index, s0)
          r0.extend(ParsingRule0)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:parsing_rule][start_index] = r0

        return r0
      end

      def _nt_parsing_expression
        start_index = index
        if node_cache[:parsing_expression].has_key?(index)
          cached = node_cache[:parsing_expression][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        r1 = _nt_choice
        if r1
          r0 = r1
        else
          r2 = _nt_sequence
          if r2
            r0 = r2
          else
            r3 = _nt_primary
            if r3
              r0 = r3
            else
              self.index = i0
              r0 = nil
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
        def head
          elements[0]
        end

        def tail
          elements[1]
        end
      end

      module Choice2
        def alternatives
          [head] + tail
        end
        
        def tail
          super.elements.map {|elt| elt.alternative}
        end
        
        def inline_modules
          (alternatives.map {|alt| alt.inline_modules }).flatten
        end
      end

      def _nt_choice
        start_index = index
        if node_cache[:choice].has_key?(index)
          cached = node_cache[:choice][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        r1 = _nt_alternative
        s0 << r1
        if r1
          s2, i2 = [], index
          loop do
            i3, s3 = index, []
            r5 = _nt_space
            if r5
              r4 = r5
            else
              r4 = SyntaxNode.new(input, index...index)
            end
            s3 << r4
            if r4
              if input.index('/', index) == index
                r6 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('/')
                r6 = nil
              end
              s3 << r6
              if r6
                r8 = _nt_space
                if r8
                  r7 = r8
                else
                  r7 = SyntaxNode.new(input, index...index)
                end
                s3 << r7
                if r7
                  r9 = _nt_alternative
                  s3 << r9
                end
              end
            end
            if s3.last
              r3 = (SyntaxNode).new(input, i3...index, s3)
              r3.extend(Choice0)
            else
              self.index = i3
              r3 = nil
            end
            if r3
              s2 << r3
            else
              break
            end
          end
          if s2.empty?
            self.index = i2
            r2 = nil
          else
            r2 = SyntaxNode.new(input, i2...index, s2)
          end
          s0 << r2
        end
        if s0.last
          r0 = (Choice).new(input, i0...index, s0)
          r0.extend(Choice1)
          r0.extend(Choice2)
        else
          self.index = i0
          r0 = nil
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
        def head
          elements[0]
        end

        def tail
          elements[1]
        end

        def node_class_declarations
          elements[2]
        end
      end

      module Sequence2
        def sequence_elements
          [head] + tail
        end
  
        def tail
          super.elements.map {|elt| elt.labeled_sequence_primary }
        end
    
        def inline_modules
          (sequence_elements.map {|elt| elt.inline_modules}).flatten +
          [sequence_element_accessor_module] +
          node_class_declarations.inline_modules
        end
    
        def inline_module_name
          node_class_declarations.inline_module_name
        end
      end

      def _nt_sequence
        start_index = index
        if node_cache[:sequence].has_key?(index)
          cached = node_cache[:sequence][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        r1 = _nt_labeled_sequence_primary
        s0 << r1
        if r1
          s2, i2 = [], index
          loop do
            i3, s3 = index, []
            r4 = _nt_space
            s3 << r4
            if r4
              r5 = _nt_labeled_sequence_primary
              s3 << r5
            end
            if s3.last
              r3 = (SyntaxNode).new(input, i3...index, s3)
              r3.extend(Sequence0)
            else
              self.index = i3
              r3 = nil
            end
            if r3
              s2 << r3
            else
              break
            end
          end
          if s2.empty?
            self.index = i2
            r2 = nil
          else
            r2 = SyntaxNode.new(input, i2...index, s2)
          end
          s0 << r2
          if r2
            r6 = _nt_node_class_declarations
            s0 << r6
          end
        end
        if s0.last
          r0 = (Sequence).new(input, i0...index, s0)
          r0.extend(Sequence1)
          r0.extend(Sequence2)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:sequence][start_index] = r0

        return r0
      end

      def _nt_alternative
        start_index = index
        if node_cache[:alternative].has_key?(index)
          cached = node_cache[:alternative][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        r1 = _nt_sequence
        if r1
          r0 = r1
        else
          r2 = _nt_primary
          if r2
            r0 = r2
          else
            self.index = i0
            r0 = nil
          end
        end

        node_cache[:alternative][start_index] = r0

        return r0
      end

      module Primary0
        def prefix
          elements[0]
        end

        def atomic
          elements[1]
        end
      end

      module Primary1
        def compile(address, builder, parent_expression=nil)
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

      module Primary2
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

      module Primary3
        def compile(address, builder, parent_expression=nil)
          suffix.compile(address, builder, self)
        end
    
        def optional_expression
          atomic
        end
    
        def node_class_name
          node_class_declarations.node_class_name
        end
    
        def inline_modules
          atomic.inline_modules + node_class_declarations.inline_modules
        end
    
        def inline_module_name
          node_class_declarations.inline_module_name
        end
      end

      module Primary4
        def atomic
          elements[0]
        end

        def node_class_declarations
          elements[1]
        end
      end

      module Primary5
        def compile(address, builder, parent_expression=nil)
          atomic.compile(address, builder, self)
        end
    
        def node_class_name
          node_class_declarations.node_class_name
        end
    
        def inline_modules
          atomic.inline_modules + node_class_declarations.inline_modules
        end
    
        def inline_module_name
          node_class_declarations.inline_module_name
        end
      end

      def _nt_primary
        start_index = index
        if node_cache[:primary].has_key?(index)
          cached = node_cache[:primary][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        i1, s1 = index, []
        r2 = _nt_prefix
        s1 << r2
        if r2
          r3 = _nt_atomic
          s1 << r3
        end
        if s1.last
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(Primary0)
          r1.extend(Primary1)
        else
          self.index = i1
          r1 = nil
        end
        if r1
          r0 = r1
        else
          i4, s4 = index, []
          r5 = _nt_atomic
          s4 << r5
          if r5
            r6 = _nt_suffix
            s4 << r6
            if r6
              r7 = _nt_node_class_declarations
              s4 << r7
            end
          end
          if s4.last
            r4 = (SyntaxNode).new(input, i4...index, s4)
            r4.extend(Primary2)
            r4.extend(Primary3)
          else
            self.index = i4
            r4 = nil
          end
          if r4
            r0 = r4
          else
            i8, s8 = index, []
            r9 = _nt_atomic
            s8 << r9
            if r9
              r10 = _nt_node_class_declarations
              s8 << r10
            end
            if s8.last
              r8 = (SyntaxNode).new(input, i8...index, s8)
              r8.extend(Primary4)
              r8.extend(Primary5)
            else
              self.index = i8
              r8 = nil
            end
            if r8
              r0 = r8
            else
              self.index = i0
              r0 = nil
            end
          end
        end

        node_cache[:primary][start_index] = r0

        return r0
      end

      module LabeledSequencePrimary0
        def label
          elements[0]
        end

        def sequence_primary
          elements[1]
        end
      end

      module LabeledSequencePrimary1
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

      def _nt_labeled_sequence_primary
        start_index = index
        if node_cache[:labeled_sequence_primary].has_key?(index)
          cached = node_cache[:labeled_sequence_primary][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        r1 = _nt_label
        s0 << r1
        if r1
          r2 = _nt_sequence_primary
          s0 << r2
        end
        if s0.last
          r0 = (SyntaxNode).new(input, i0...index, s0)
          r0.extend(LabeledSequencePrimary0)
          r0.extend(LabeledSequencePrimary1)
        else
          self.index = i0
          r0 = nil
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
      end

      module Label2
        def name
          elements[0].text_value
        end
      end

      module Label3
        def name
          nil
        end
      end

      def _nt_label
        start_index = index
        if node_cache[:label].has_key?(index)
          cached = node_cache[:label][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        i1, s1 = index, []
        i2, s2 = index, []
        r3 = _nt_alpha_char
        s2 << r3
        if r3
          s4, i4 = [], index
          loop do
            r5 = _nt_alphanumeric_char
            if r5
              s4 << r5
            else
              break
            end
          end
          r4 = SyntaxNode.new(input, i4...index, s4)
          s2 << r4
        end
        if s2.last
          r2 = (SyntaxNode).new(input, i2...index, s2)
          r2.extend(Label0)
        else
          self.index = i2
          r2 = nil
        end
        s1 << r2
        if r2
          if input.index(':', index) == index
            r6 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(':')
            r6 = nil
          end
          s1 << r6
        end
        if s1.last
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(Label1)
          r1.extend(Label2)
        else
          self.index = i1
          r1 = nil
        end
        if r1
          r0 = r1
        else
          if input.index('', index) == index
            r7 = (SyntaxNode).new(input, index...(index + 0))
            r7.extend(Label3)
            @index += 0
          else
            terminal_parse_failure('')
            r7 = nil
          end
          if r7
            r0 = r7
          else
            self.index = i0
            r0 = nil
          end
        end

        node_cache[:label][start_index] = r0

        return r0
      end

      module SequencePrimary0
        def prefix
          elements[0]
        end

        def atomic
          elements[1]
        end
      end

      module SequencePrimary1
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

      module SequencePrimary2
        def atomic
          elements[0]
        end

        def suffix
          elements[1]
        end
      end

      module SequencePrimary3
        def compile(lexical_address, builder)
          suffix.compile(lexical_address, builder, self)
        end
    
        def node_class_name
          nil
        end
    
        def inline_modules
          atomic.inline_modules
        end
    
        def inline_module_name
          nil
        end
      end

      def _nt_sequence_primary
        start_index = index
        if node_cache[:sequence_primary].has_key?(index)
          cached = node_cache[:sequence_primary][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        i1, s1 = index, []
        r2 = _nt_prefix
        s1 << r2
        if r2
          r3 = _nt_atomic
          s1 << r3
        end
        if s1.last
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(SequencePrimary0)
          r1.extend(SequencePrimary1)
        else
          self.index = i1
          r1 = nil
        end
        if r1
          r0 = r1
        else
          i4, s4 = index, []
          r5 = _nt_atomic
          s4 << r5
          if r5
            r6 = _nt_suffix
            s4 << r6
          end
          if s4.last
            r4 = (SyntaxNode).new(input, i4...index, s4)
            r4.extend(SequencePrimary2)
            r4.extend(SequencePrimary3)
          else
            self.index = i4
            r4 = nil
          end
          if r4
            r0 = r4
          else
            r7 = _nt_atomic
            if r7
              r0 = r7
            else
              self.index = i0
              r0 = nil
            end
          end
        end

        node_cache[:sequence_primary][start_index] = r0

        return r0
      end

      def _nt_suffix
        start_index = index
        if node_cache[:suffix].has_key?(index)
          cached = node_cache[:suffix][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        r1 = _nt_repetition_suffix
        if r1
          r0 = r1
        else
          r2 = _nt_optional_suffix
          if r2
            r0 = r2
          else
            self.index = i0
            r0 = nil
          end
        end

        node_cache[:suffix][start_index] = r0

        return r0
      end

      def _nt_optional_suffix
        start_index = index
        if node_cache[:optional_suffix].has_key?(index)
          cached = node_cache[:optional_suffix][index]
          @index = cached.interval.end if cached
          return cached
        end

        if input.index('?', index) == index
          r0 = (Optional).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('?')
          r0 = nil
        end

        node_cache[:optional_suffix][start_index] = r0

        return r0
      end

      module NodeClassDeclarations0
        def node_class_expression
          elements[0]
        end

        def trailing_inline_module
          elements[1]
        end
      end

      module NodeClassDeclarations1
        def node_class_name
          node_class_expression.node_class_name
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
        start_index = index
        if node_cache[:node_class_declarations].has_key?(index)
          cached = node_cache[:node_class_declarations][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        r1 = _nt_node_class_expression
        s0 << r1
        if r1
          r2 = _nt_trailing_inline_module
          s0 << r2
        end
        if s0.last
          r0 = (SyntaxNode).new(input, i0...index, s0)
          r0.extend(NodeClassDeclarations0)
          r0.extend(NodeClassDeclarations1)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:node_class_declarations][start_index] = r0

        return r0
      end

      def _nt_repetition_suffix
        start_index = index
        if node_cache[:repetition_suffix].has_key?(index)
          cached = node_cache[:repetition_suffix][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        if input.index('+', index) == index
          r1 = (OneOrMore).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('+')
          r1 = nil
        end
        if r1
          r0 = r1
        else
          if input.index('*', index) == index
            r2 = (ZeroOrMore).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('*')
            r2 = nil
          end
          if r2
            r0 = r2
          else
            self.index = i0
            r0 = nil
          end
        end

        node_cache[:repetition_suffix][start_index] = r0

        return r0
      end

      def _nt_prefix
        start_index = index
        if node_cache[:prefix].has_key?(index)
          cached = node_cache[:prefix][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        if input.index('&', index) == index
          r1 = (AndPredicate).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('&')
          r1 = nil
        end
        if r1
          r0 = r1
        else
          if input.index('!', index) == index
            r2 = (NotPredicate).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('!')
            r2 = nil
          end
          if r2
            r0 = r2
          else
            self.index = i0
            r0 = nil
          end
        end

        node_cache[:prefix][start_index] = r0

        return r0
      end

      def _nt_atomic
        start_index = index
        if node_cache[:atomic].has_key?(index)
          cached = node_cache[:atomic][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        r1 = _nt_terminal
        if r1
          r0 = r1
        else
          r2 = _nt_nonterminal
          if r2
            r0 = r2
          else
            r3 = _nt_parenthesized_expression
            if r3
              r0 = r3
            else
              self.index = i0
              r0 = nil
            end
          end
        end

        node_cache[:atomic][start_index] = r0

        return r0
      end

      module ParenthesizedExpression0
        def parsing_expression
          elements[2]
        end

      end

      module ParenthesizedExpression1
        def inline_modules
          parsing_expression.inline_modules
        end
      end

      def _nt_parenthesized_expression
        start_index = index
        if node_cache[:parenthesized_expression].has_key?(index)
          cached = node_cache[:parenthesized_expression][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        if input.index('(', index) == index
          r1 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r1 = nil
        end
        s0 << r1
        if r1
          r3 = _nt_space
          if r3
            r2 = r3
          else
            r2 = SyntaxNode.new(input, index...index)
          end
          s0 << r2
          if r2
            r4 = _nt_parsing_expression
            s0 << r4
            if r4
              r6 = _nt_space
              if r6
                r5 = r6
              else
                r5 = SyntaxNode.new(input, index...index)
              end
              s0 << r5
              if r5
                if input.index(')', index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(')')
                  r7 = nil
                end
                s0 << r7
              end
            end
          end
        end
        if s0.last
          r0 = (ParenthesizedExpression).new(input, i0...index, s0)
          r0.extend(ParenthesizedExpression0)
          r0.extend(ParenthesizedExpression1)
        else
          self.index = i0
          r0 = nil
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
        if node_cache[:nonterminal].has_key?(index)
          cached = node_cache[:nonterminal][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        i1 = index
        r2 = _nt_keyword_inside_grammar
        if r2
          r1 = nil
        else
          self.index = i1
          r1 = SyntaxNode.new(input, index...index)
        end
        s0 << r1
        if r1
          i3, s3 = index, []
          r4 = _nt_alpha_char
          s3 << r4
          if r4
            s5, i5 = [], index
            loop do
              r6 = _nt_alphanumeric_char
              if r6
                s5 << r6
              else
                break
              end
            end
            r5 = SyntaxNode.new(input, i5...index, s5)
            s3 << r5
          end
          if s3.last
            r3 = (SyntaxNode).new(input, i3...index, s3)
            r3.extend(Nonterminal0)
          else
            self.index = i3
            r3 = nil
          end
          s0 << r3
        end
        if s0.last
          r0 = (Nonterminal).new(input, i0...index, s0)
          r0.extend(Nonterminal1)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:nonterminal][start_index] = r0

        return r0
      end

      def _nt_terminal
        start_index = index
        if node_cache[:terminal].has_key?(index)
          cached = node_cache[:terminal][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        r1 = _nt_quoted_string
        if r1
          r0 = r1
        else
          r2 = _nt_character_class
          if r2
            r0 = r2
          else
            r3 = _nt_anything_symbol
            if r3
              r0 = r3
            else
              self.index = i0
              r0 = nil
            end
          end
        end

        node_cache[:terminal][start_index] = r0

        return r0
      end

      module QuotedString0
        def string
          super.text_value
        end
      end

      def _nt_quoted_string
        start_index = index
        if node_cache[:quoted_string].has_key?(index)
          cached = node_cache[:quoted_string][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        r1 = _nt_single_quoted_string
        if r1
          r0 = r1
          r0.extend(QuotedString0)
        else
          r2 = _nt_double_quoted_string
          if r2
            r0 = r2
            r0.extend(QuotedString0)
          else
            self.index = i0
            r0 = nil
          end
        end

        node_cache[:quoted_string][start_index] = r0

        return r0
      end

      module DoubleQuotedString0
      end

      module DoubleQuotedString1
        def string
          elements[1]
        end

      end

      def _nt_double_quoted_string
        start_index = index
        if node_cache[:double_quoted_string].has_key?(index)
          cached = node_cache[:double_quoted_string][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        if input.index('"', index) == index
          r1 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('"')
          r1 = nil
        end
        s0 << r1
        if r1
          s2, i2 = [], index
          loop do
            i3, s3 = index, []
            i4 = index
            if input.index('"', index) == index
              r5 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('"')
              r5 = nil
            end
            if r5
              r4 = nil
            else
              self.index = i4
              r4 = SyntaxNode.new(input, index...index)
            end
            s3 << r4
            if r4
              i6 = index
              if input.index("\\\\", index) == index
                r7 = (SyntaxNode).new(input, index...(index + 2))
                @index += 2
              else
                terminal_parse_failure("\\\\")
                r7 = nil
              end
              if r7
                r6 = r7
              else
                if input.index('\"', index) == index
                  r8 = (SyntaxNode).new(input, index...(index + 2))
                  @index += 2
                else
                  terminal_parse_failure('\"')
                  r8 = nil
                end
                if r8
                  r6 = r8
                else
                  if index < input_length
                    r9 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure("any character")
                    r9 = nil
                  end
                  if r9
                    r6 = r9
                  else
                    self.index = i6
                    r6 = nil
                  end
                end
              end
              s3 << r6
            end
            if s3.last
              r3 = (SyntaxNode).new(input, i3...index, s3)
              r3.extend(DoubleQuotedString0)
            else
              self.index = i3
              r3 = nil
            end
            if r3
              s2 << r3
            else
              break
            end
          end
          r2 = SyntaxNode.new(input, i2...index, s2)
          s0 << r2
          if r2
            if input.index('"', index) == index
              r10 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('"')
              r10 = nil
            end
            s0 << r10
          end
        end
        if s0.last
          r0 = (Terminal).new(input, i0...index, s0)
          r0.extend(DoubleQuotedString1)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:double_quoted_string][start_index] = r0

        return r0
      end

      module SingleQuotedString0
      end

      module SingleQuotedString1
        def string
          elements[1]
        end

      end

      def _nt_single_quoted_string
        start_index = index
        if node_cache[:single_quoted_string].has_key?(index)
          cached = node_cache[:single_quoted_string][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        if input.index("'", index) == index
          r1 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("'")
          r1 = nil
        end
        s0 << r1
        if r1
          s2, i2 = [], index
          loop do
            i3, s3 = index, []
            i4 = index
            if input.index("'", index) == index
              r5 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("'")
              r5 = nil
            end
            if r5
              r4 = nil
            else
              self.index = i4
              r4 = SyntaxNode.new(input, index...index)
            end
            s3 << r4
            if r4
              i6 = index
              if input.index("\\\\", index) == index
                r7 = (SyntaxNode).new(input, index...(index + 2))
                @index += 2
              else
                terminal_parse_failure("\\\\")
                r7 = nil
              end
              if r7
                r6 = r7
              else
                if input.index("\\'", index) == index
                  r8 = (SyntaxNode).new(input, index...(index + 2))
                  @index += 2
                else
                  terminal_parse_failure("\\'")
                  r8 = nil
                end
                if r8
                  r6 = r8
                else
                  if index < input_length
                    r9 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure("any character")
                    r9 = nil
                  end
                  if r9
                    r6 = r9
                  else
                    self.index = i6
                    r6 = nil
                  end
                end
              end
              s3 << r6
            end
            if s3.last
              r3 = (SyntaxNode).new(input, i3...index, s3)
              r3.extend(SingleQuotedString0)
            else
              self.index = i3
              r3 = nil
            end
            if r3
              s2 << r3
            else
              break
            end
          end
          r2 = SyntaxNode.new(input, i2...index, s2)
          s0 << r2
          if r2
            if input.index("'", index) == index
              r10 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("'")
              r10 = nil
            end
            s0 << r10
          end
        end
        if s0.last
          r0 = (Terminal).new(input, i0...index, s0)
          r0.extend(SingleQuotedString1)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:single_quoted_string][start_index] = r0

        return r0
      end

      module CharacterClass0
      end

      module CharacterClass1
      end

      module CharacterClass2
      end

      module CharacterClass3
        def characters
          elements[1]
        end

      end

      module CharacterClass4
        def characters
          super.text_value
        end
      end

      def _nt_character_class
        start_index = index
        if node_cache[:character_class].has_key?(index)
          cached = node_cache[:character_class][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        if input.index('[', index) == index
          r1 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('[')
          r1 = nil
        end
        s0 << r1
        if r1
          s2, i2 = [], index
          loop do
            i3, s3 = index, []
            i4 = index
            if input.index(']', index) == index
              r5 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(']')
              r5 = nil
            end
            if r5
              r4 = nil
            else
              self.index = i4
              r4 = SyntaxNode.new(input, index...index)
            end
            s3 << r4
            if r4
              i6 = index
              i7, s7 = index, []
              if input.index('\\', index) == index
                r8 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('\\')
                r8 = nil
              end
              s7 << r8
              if r8
                if index < input_length
                  r9 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure("any character")
                  r9 = nil
                end
                s7 << r9
              end
              if s7.last
                r7 = (SyntaxNode).new(input, i7...index, s7)
                r7.extend(CharacterClass0)
              else
                self.index = i7
                r7 = nil
              end
              if r7
                r6 = r7
              else
                i10, s10 = index, []
                i11 = index
                if input.index('\\', index) == index
                  r12 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('\\')
                  r12 = nil
                end
                if r12
                  r11 = nil
                else
                  self.index = i11
                  r11 = SyntaxNode.new(input, index...index)
                end
                s10 << r11
                if r11
                  if index < input_length
                    r13 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure("any character")
                    r13 = nil
                  end
                  s10 << r13
                end
                if s10.last
                  r10 = (SyntaxNode).new(input, i10...index, s10)
                  r10.extend(CharacterClass1)
                else
                  self.index = i10
                  r10 = nil
                end
                if r10
                  r6 = r10
                else
                  self.index = i6
                  r6 = nil
                end
              end
              s3 << r6
            end
            if s3.last
              r3 = (SyntaxNode).new(input, i3...index, s3)
              r3.extend(CharacterClass2)
            else
              self.index = i3
              r3 = nil
            end
            if r3
              s2 << r3
            else
              break
            end
          end
          if s2.empty?
            self.index = i2
            r2 = nil
          else
            r2 = SyntaxNode.new(input, i2...index, s2)
          end
          s0 << r2
          if r2
            if input.index(']', index) == index
              r14 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(']')
              r14 = nil
            end
            s0 << r14
          end
        end
        if s0.last
          r0 = (CharacterClass).new(input, i0...index, s0)
          r0.extend(CharacterClass3)
          r0.extend(CharacterClass4)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:character_class][start_index] = r0

        return r0
      end

      def _nt_anything_symbol
        start_index = index
        if node_cache[:anything_symbol].has_key?(index)
          cached = node_cache[:anything_symbol][index]
          @index = cached.interval.end if cached
          return cached
        end

        if input.index('.', index) == index
          r0 = (AnythingSymbol).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('.')
          r0 = nil
        end

        node_cache[:anything_symbol][start_index] = r0

        return r0
      end

      module NodeClassExpression0
      end

      module NodeClassExpression1
        def space
          elements[0]
        end

      end

      module NodeClassExpression2
        def node_class_name
          elements[2].text_value
        end
      end

      module NodeClassExpression3
        def node_class_name
          nil
        end
      end

      def _nt_node_class_expression
        start_index = index
        if node_cache[:node_class_expression].has_key?(index)
          cached = node_cache[:node_class_expression][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        i1, s1 = index, []
        r2 = _nt_space
        s1 << r2
        if r2
          if input.index('<', index) == index
            r3 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('<')
            r3 = nil
          end
          s1 << r3
          if r3
            s4, i4 = [], index
            loop do
              i5, s5 = index, []
              i6 = index
              if input.index('>', index) == index
                r7 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('>')
                r7 = nil
              end
              if r7
                r6 = nil
              else
                self.index = i6
                r6 = SyntaxNode.new(input, index...index)
              end
              s5 << r6
              if r6
                if index < input_length
                  r8 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure("any character")
                  r8 = nil
                end
                s5 << r8
              end
              if s5.last
                r5 = (SyntaxNode).new(input, i5...index, s5)
                r5.extend(NodeClassExpression0)
              else
                self.index = i5
                r5 = nil
              end
              if r5
                s4 << r5
              else
                break
              end
            end
            if s4.empty?
              self.index = i4
              r4 = nil
            else
              r4 = SyntaxNode.new(input, i4...index, s4)
            end
            s1 << r4
            if r4
              if input.index('>', index) == index
                r9 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('>')
                r9 = nil
              end
              s1 << r9
            end
          end
        end
        if s1.last
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(NodeClassExpression1)
          r1.extend(NodeClassExpression2)
        else
          self.index = i1
          r1 = nil
        end
        if r1
          r0 = r1
        else
          if input.index('', index) == index
            r10 = (SyntaxNode).new(input, index...(index + 0))
            r10.extend(NodeClassExpression3)
            @index += 0
          else
            terminal_parse_failure('')
            r10 = nil
          end
          if r10
            r0 = r10
          else
            self.index = i0
            r0 = nil
          end
        end

        node_cache[:node_class_expression][start_index] = r0

        return r0
      end

      module TrailingInlineModule0
        def space
          elements[0]
        end

        def inline_module
          elements[1]
        end
      end

      module TrailingInlineModule1
        def inline_modules
          [inline_module]
        end
              
        def inline_module_name
          inline_module.module_name
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
        if node_cache[:trailing_inline_module].has_key?(index)
          cached = node_cache[:trailing_inline_module][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        i1, s1 = index, []
        r2 = _nt_space
        s1 << r2
        if r2
          r3 = _nt_inline_module
          s1 << r3
        end
        if s1.last
          r1 = (SyntaxNode).new(input, i1...index, s1)
          r1.extend(TrailingInlineModule0)
          r1.extend(TrailingInlineModule1)
        else
          self.index = i1
          r1 = nil
        end
        if r1
          r0 = r1
        else
          if input.index('', index) == index
            r4 = (SyntaxNode).new(input, index...(index + 0))
            r4.extend(TrailingInlineModule2)
            @index += 0
          else
            terminal_parse_failure('')
            r4 = nil
          end
          if r4
            r0 = r4
          else
            self.index = i0
            r0 = nil
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
        if node_cache[:inline_module].has_key?(index)
          cached = node_cache[:inline_module][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        if input.index('{', index) == index
          r1 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('{')
          r1 = nil
        end
        s0 << r1
        if r1
          s2, i2 = [], index
          loop do
            i3 = index
            r4 = _nt_inline_module
            if r4
              r3 = r4
            else
              i5, s5 = index, []
              i6 = index
              if input.index(Regexp.new('[{}]'), index) == index
                r7 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                r7 = nil
              end
              if r7
                r6 = nil
              else
                self.index = i6
                r6 = SyntaxNode.new(input, index...index)
              end
              s5 << r6
              if r6
                if index < input_length
                  r8 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure("any character")
                  r8 = nil
                end
                s5 << r8
              end
              if s5.last
                r5 = (SyntaxNode).new(input, i5...index, s5)
                r5.extend(InlineModule0)
              else
                self.index = i5
                r5 = nil
              end
              if r5
                r3 = r5
              else
                self.index = i3
                r3 = nil
              end
            end
            if r3
              s2 << r3
            else
              break
            end
          end
          r2 = SyntaxNode.new(input, i2...index, s2)
          s0 << r2
          if r2
            if input.index('}', index) == index
              r9 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('}')
              r9 = nil
            end
            s0 << r9
          end
        end
        if s0.last
          r0 = (InlineModule).new(input, i0...index, s0)
          r0.extend(InlineModule1)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:inline_module][start_index] = r0

        return r0
      end

      module KeywordInsideGrammar0
      end

      def _nt_keyword_inside_grammar
        start_index = index
        if node_cache[:keyword_inside_grammar].has_key?(index)
          cached = node_cache[:keyword_inside_grammar][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        i1 = index
        if input.index('rule', index) == index
          r2 = (SyntaxNode).new(input, index...(index + 4))
          @index += 4
        else
          terminal_parse_failure('rule')
          r2 = nil
        end
        if r2
          r1 = r2
        else
          if input.index('end', index) == index
            r3 = (SyntaxNode).new(input, index...(index + 3))
            @index += 3
          else
            terminal_parse_failure('end')
            r3 = nil
          end
          if r3
            r1 = r3
          else
            self.index = i1
            r1 = nil
          end
        end
        s0 << r1
        if r1
          i4 = index
          r5 = _nt_non_space_char
          if r5
            r4 = nil
          else
            self.index = i4
            r4 = SyntaxNode.new(input, index...index)
          end
          s0 << r4
        end
        if s0.last
          r0 = (SyntaxNode).new(input, i0...index, s0)
          r0.extend(KeywordInsideGrammar0)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:keyword_inside_grammar][start_index] = r0

        return r0
      end

      module NonSpaceChar0
      end

      def _nt_non_space_char
        start_index = index
        if node_cache[:non_space_char].has_key?(index)
          cached = node_cache[:non_space_char][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        i1 = index
        r2 = _nt_space
        if r2
          r1 = nil
        else
          self.index = i1
          r1 = SyntaxNode.new(input, index...index)
        end
        s0 << r1
        if r1
          if index < input_length
            r3 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("any character")
            r3 = nil
          end
          s0 << r3
        end
        if s0.last
          r0 = (SyntaxNode).new(input, i0...index, s0)
          r0.extend(NonSpaceChar0)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:non_space_char][start_index] = r0

        return r0
      end

      def _nt_alpha_char
        start_index = index
        if node_cache[:alpha_char].has_key?(index)
          cached = node_cache[:alpha_char][index]
          @index = cached.interval.end if cached
          return cached
        end

        if input.index(Regexp.new('[A-Za-z_]'), index) == index
          r0 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r0 = nil
        end

        node_cache[:alpha_char][start_index] = r0

        return r0
      end

      def _nt_alphanumeric_char
        start_index = index
        if node_cache[:alphanumeric_char].has_key?(index)
          cached = node_cache[:alphanumeric_char][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0 = index
        r1 = _nt_alpha_char
        if r1
          r0 = r1
        else
          if input.index(Regexp.new('[0-9]'), index) == index
            r2 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            r2 = nil
          end
          if r2
            r0 = r2
          else
            self.index = i0
            r0 = nil
          end
        end

        node_cache[:alphanumeric_char][start_index] = r0

        return r0
      end

      def _nt_space
        start_index = index
        if node_cache[:space].has_key?(index)
          cached = node_cache[:space][index]
          @index = cached.interval.end if cached
          return cached
        end

        s0, i0 = [], index
        loop do
          i1 = index
          r2 = _nt_white
          if r2
            r1 = r2
          else
            r3 = _nt_comment_to_eol
            if r3
              r1 = r3
            else
              self.index = i1
              r1 = nil
            end
          end
          if r1
            s0 << r1
          else
            break
          end
        end
        if s0.empty?
          self.index = i0
          r0 = nil
        else
          r0 = SyntaxNode.new(input, i0...index, s0)
        end

        node_cache[:space][start_index] = r0

        return r0
      end

      module CommentToEol0
      end

      module CommentToEol1
      end

      def _nt_comment_to_eol
        start_index = index
        if node_cache[:comment_to_eol].has_key?(index)
          cached = node_cache[:comment_to_eol][index]
          @index = cached.interval.end if cached
          return cached
        end

        i0, s0 = index, []
        if input.index('#', index) == index
          r1 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('#')
          r1 = nil
        end
        s0 << r1
        if r1
          s2, i2 = [], index
          loop do
            i3, s3 = index, []
            i4 = index
            if input.index("\n", index) == index
              r5 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("\n")
              r5 = nil
            end
            if r5
              r4 = nil
            else
              self.index = i4
              r4 = SyntaxNode.new(input, index...index)
            end
            s3 << r4
            if r4
              if index < input_length
                r6 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("any character")
                r6 = nil
              end
              s3 << r6
            end
            if s3.last
              r3 = (SyntaxNode).new(input, i3...index, s3)
              r3.extend(CommentToEol0)
            else
              self.index = i3
              r3 = nil
            end
            if r3
              s2 << r3
            else
              break
            end
          end
          if s2.empty?
            self.index = i2
            r2 = nil
          else
            r2 = SyntaxNode.new(input, i2...index, s2)
          end
          s0 << r2
        end
        if s0.last
          r0 = (SyntaxNode).new(input, i0...index, s0)
          r0.extend(CommentToEol1)
        else
          self.index = i0
          r0 = nil
        end

        node_cache[:comment_to_eol][start_index] = r0

        return r0
      end

      def _nt_white
        start_index = index
        if node_cache[:white].has_key?(index)
          cached = node_cache[:white][index]
          @index = cached.interval.end if cached
          return cached
        end

        if input.index(Regexp.new('[ \t\n\r]'), index) == index
          r0 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r0 = nil
        end

        node_cache[:white][start_index] = r0

        return r0
      end

    end

    class MetagrammarParser < Treetop::Runtime::CompiledParser
      include Metagrammar
    end

  end
end
