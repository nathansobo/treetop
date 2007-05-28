module Treetop
  class ParseFailure < ParseResult
    attr_reader :index
    
    if !OPTIMIZE
      def initialize(index, nested_results = [])
        super(nested_results)
        @index = index
      end
    else
      inline do |builder|
        builder.c_raw <<-C
          VALUE initialize(int argc, VALUE* argv, VALUE self) {
            VALUE index, nested_results;
            if (rb_scan_args(argc, argv, "11", &index, &nested_results) == 1) {
              nested_results = rb_ary_new();
            }
            VALUE super_args[1];
            super_args[0] = nested_results;
            rb_call_super(1, super_args);
            
            rb_iv_set(self, "@index", index);
            return self;
          }
        C
      end
    end
    
    def success?
      false
    end
    
    def failure?
      true
    end
    
    def interval      
      @interval ||= (index...index)
    end    
  end
end