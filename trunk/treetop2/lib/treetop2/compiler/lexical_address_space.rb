module Treetop2
  module Compiler
    class LexicalAddressSpace
      def initialize
        @next_address = -1
      end
      
      def next_address
        @next_address += 1
      end
    end
  end
end