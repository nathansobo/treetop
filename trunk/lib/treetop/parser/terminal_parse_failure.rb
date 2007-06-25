module Treetop
  class TerminalParseFailure < ParseFailure
    attr_reader :expression


    if !OPTIMIZE
      def initialize(expression, index)
        super(index)
        @expression = expression      
      end
    else
      inline do |builder|
        builder.c <<-C
          VALUE initialize(VALUE expression, VALUE index) {
            VALUE super_args[1];
            super_args[0] = index;
            rb_call_super(1, super_args);
            
            rb_iv_set(self, "@expression", expression);
            return self;
          }
        C
      end
    end
    
    def nested_failures
      [self]
    end
    
    def to_s
      "String matching #{expression} expected at position #{index}."
    end
  end
end