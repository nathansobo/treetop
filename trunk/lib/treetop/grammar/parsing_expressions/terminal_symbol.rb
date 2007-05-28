module Treetop
  class TerminalSymbol < TerminalParsingExpression
    attr_accessor :prefix
    
    def self.epsilon
      @epsilon ||= self.new("")
    end
    
    def initialize(prefix)
      super()
      self.prefix = prefix
    end
    
    def epsilon?
      prefix.blank?
    end
            
    def to_s
      "\"#{prefix}\""
    end

    if !OPTIMIZE
      def parse_at(input, start_index, parser)
        if input.index(prefix, start_index) == start_index
          return node_class.new(input, start_index...(prefix.length + start_index))
        else
          TerminalParseFailure.new(start_index, self)
        end
      end
    else
      inline do |builder|
        builder.prefix <<-C
          int id_prefix;
          int id_node_class;
          VALUE mTreetop;
          VALUE cTerminalParseFailure;
        C
        
        builder.add_to_init <<-C
          id_prefix = rb_intern("prefix");
          id_node_class = rb_intern("node_class");
          mTreetop = rb_const_get(rb_cObject, rb_intern("Treetop"));          
          cTerminalParseFailure = rb_const_get(mTreetop, rb_intern("TerminalParseFailure"));
        C
                
        builder.c <<-C
          VALUE parse_at(VALUE input, int start_index, VALUE parser) {
            int i, prefix_length, input_length;
            char *prefix_ptr, *input_ptr;
            VALUE parse_failure_argv[2], node_class_argv[2];
            VALUE node_class;
            
            VALUE prefix = rb_funcall(self, id_prefix, 0);

            input_ptr = RSTRING(input)->ptr;
            input_length = RSTRING(input)->len;
            prefix_ptr = RSTRING(prefix)->ptr;
            prefix_length = RSTRING(prefix)->len;
    
            for (i = 0; i < prefix_length; i++) {
              if (i >= input_length || input_ptr[i + start_index] != prefix_ptr[i]) {
                parse_failure_argv[0] = INT2NUM(start_index);
                parse_failure_argv[1] = self;
                return rb_class_new_instance(2, parse_failure_argv, cTerminalParseFailure);
              }
            }
          
            node_class = rb_funcall(self, id_node_class, 0);
            node_class_argv[0] = input;
            node_class_argv[1] = rb_range_new(INT2NUM(start_index), INT2NUM(prefix_length + start_index), 1);
            return (rb_class_new_instance(2, node_class_argv, node_class));
          }
        C
      end
    end
  end
end