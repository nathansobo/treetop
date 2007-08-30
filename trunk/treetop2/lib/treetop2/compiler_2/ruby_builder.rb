module Treetop2
  module Compiler2
    class RubyBuilder
      
      attr_reader :level, :address_space, :ruby
      
      def initialize
        @level = 0
        @address_space = LexicalAddressSpace.new
        @ruby = ""
      end
      
      def <<(ruby_line)
        return if ruby_line.blank?
        ruby << indent << ruby_line << "\n"
      end
      
      def indented(depth = 1)
        self.in(depth)
        yield
        self.out(depth)
      end
      
      def assign(left, right)
        if left.instance_of? Array
          self << "#{left.join(', ')} = #{right.join(', ')}"
        else
          self << "#{left} = #{right}"
        end
      end
      
      def accumulate(left, right)
        self << "#{left} << #{right}"
      end
      
      def if__(condition, &block)
        self << "if #{condition}"
        indented(&block)
      end
      
      def if_(condition, &block)
        if__(condition, &block)
        self << 'end'
      end
      
      def else_(&block)
        self << 'else'
        indented(&block)
        self << 'end'
      end
      
      def loop(&block)
        self << 'loop do'
        indented(&block)
        self << 'end'
      end
      
      def break
        self << 'break'
      end
            
      def next_address
        address_space.next_address
      end
      
      def reset_addresses
        address_space.reset_addresses
      end
      
      protected
      
      def in(depth = 1)
        @level += depth
        self
      end
      
      def out(depth = 1)
        @level -= depth
        self
      end
      
      def indent
        "  " * level
      end
    end
  end
end