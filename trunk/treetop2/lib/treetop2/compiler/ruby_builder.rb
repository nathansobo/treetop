module Treetop2
  module Compiler
    class RubyBuilder
      
      attr_reader :level, :address_space, :ruby
      
      def initialize
        @level = 0
        @address_space = LexicalAddressSpace.new
        @ruby = ""
      end
      
      def <<(ruby_line)
        ruby << indent << ruby_line << "\n"
      end
      
      def in(depth = 1)
        @level += depth
        self
      end
      
      def out(depth = 1)
        @level -= depth
        self
      end
      
      def indented
        self.in
        yield
        self.out
      end

      def next_address
        address_space.next_address
      end
        
      protected
      
      def indent
        "  " * level
      end
      
      
      
    end
  end
end