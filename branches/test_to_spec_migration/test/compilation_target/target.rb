class Target < Treetop::Runtime::CompiledParser
  class Bar < SyntaxNode
    
  end
  
  
  attr_accessor :root
  
  def initialize
    self.root = :foo
  end
  
  def parse(input)
    prepare_to_parse(input)
    return self.send("_nt_#{root}".to_sym)
  end
  

  module FooInlineModule
    def foo
      'foo'
    end
  end
  
  # parsing expression:
  # 'a' ('b' 'c' / 'b' 'd')+ 'e' 

  # lexical address assignment for results
  # 'a' ('b' 'c' / 'b' 'd')+ 'e'
  #       5   6     8   9     10
  #         4         7
  #              3
  #  1           2
  #              0
  def _nt_foo
    s0, i0 = [], index
  
    r1 = parse_terminal('a')
    
    s0 << r1
    if s0.last.success?
      # begin + closure
      s2, nr2, i2 = [], [], index
      loop do
        # begin ('b' 'c' / 'b' 'd')
        nr3, i3 = [], index
        # begin 'b' 'c'
        s4, i4 = [], index
        r5 = parse_terminal('b')
        s4 << r5
        if s4.last.success?
          r6 = parse_terminal('c')
          s4 << r6
        end
          
        if s4.last.success?
          r4 = SyntaxNode.new(input, i4...index, s4)
        else
          self.index = i4
          r4 = ParseFailure.new(input, i4, s4)
        end
        # end 'b' 'c'; result in r4
        
        nr3 << r4
        
        # test if we need to try expression 3's next alternative
        if r4.success?
          r3 = r4
        else
          # begin 'b' 'd'
          s7, i7 = [], index
          r8 = parse_terminal('b')
          s7 << r8
          if s7.last.success?
            r9 = parse_terminal('d')
            s7 << r9
          end
          
          if s7.last.success?
            r7 = SyntaxNode.new(input, i7...index, s7)
          else
            self.index = i7
            r7 = ParseFailure.new(input, i7, s7)
          end
          # end 'b' 'c'; result in r7
          
          nr3 << r7
          
          if r7.success?
            r3 = r7
          else          
            self.index = i3
            r3 = ParseFailure.new(input, i3, nr3)
          end
        end                
        # end ('b' 'c' / 'b' 'd'); result in r3 
        nr2 << r3
        if r3.success?
          s2 << r3
        else
          break 
        end
      end
      
      # s2 has intermediate results of the + closure
      if s2.empty?
        self.index = i2
        r2 = ParseFailure.new(input, i2, nr2)
      else
        r2 = SyntaxNode.new(input, i2...index, s2, nr2)
      end      
      # end + closure; results in r2
      
      s0 << r2 # put r2 on sequence
    
      if s0.last.success?
        r10 = parse_terminal('e')
        s0 << r10
      end
    
      if s0.last.success?
        r0 = Bar.new(input, i0...index, s0)
      else
        self.index = i0
        r0 = ParseFailure.new(input, i0, s0)
      end
      # end of the sequence... r0 has a value
      
      r0.extend(FooInlineModule)
      
      return r0
    end
  end
  
  def _nt_optional
    r1 = parse_terminal('foo')
    if r1.success?
      r0 = r1
    else
      r0 = SyntaxNode.new(input, index...index, r1.nested_failures)
    end
  end
end