module Treetop
  class Sequence < NodeInstantiatingParsingExpression
    attr_reader :elements, :node_class
    
    def initialize(elements)
      super()
      @elements = elements
    end
    
    def node_superclass
      SequenceSyntaxNode
    end
        
    def to_s
      parenthesize((@elements.collect {|elt| elt.to_s}).join(" "))
    end

    if !OPTIMIZE
      def parse_at(input, start_index, parser)
        results = []
        next_index = start_index

        for elt in elements
          result = elt.parse_at(input, next_index, parser)
          results << result
          return failure_at(start_index, results) if result.failure?
          next_index = result.interval.end
        end
        
        return node_class.new(input, (start_index...next_index), results, results)
      end
    else
      inline do |builder|
        builder.prefix <<-C
          int id_elements, id_parse_at, id_failurep, id_failure_at, id_interval, id_success, id_end, id_node_class;
        C
        
        builder.add_to_init <<-C
          id_elements = rb_intern("elements");
          id_parse_at = rb_intern("parse_at");
          id_failurep = rb_intern("failure?");
          id_failure_at = rb_intern("failure_at");
          id_interval = rb_intern("interval");
          id_success = rb_intern("success");
          id_end = rb_intern("end");
          id_node_class = rb_intern("node_class");
        C
        
        builder.c <<-C
          VALUE parse_at(VALUE input, int start_index, VALUE parser) {
            int i;
            VALUE result, interval, elt;
            
            VALUE results = rb_ary_new();
            int next_index = start_index;
            VALUE node_class_args[4];
            
            VALUE elements = rb_funcall(self, id_elements, 0);
            int elements_len = RARRAY_LEN(elements);
            VALUE *elements_ptr = RARRAY_PTR(elements);
            
            for (i = 0; i < elements_len; i++) {
              elt = elements_ptr[i];
              
              result = rb_funcall(elt, id_parse_at, 3, input, INT2NUM(next_index), parser);
              rb_ary_push(results, result);
              if (TYPE(rb_funcall(result, id_failurep, 0)) == T_TRUE) {
                return rb_funcall(self, id_failure_at, 2, INT2NUM(start_index), results);
              }
              next_index = NUM2INT(rb_funcall(rb_funcall(result, id_interval, 0), id_end, 0));
            }
            
            VALUE node_class = rb_funcall(self, id_node_class, 0);
            interval = rb_range_new(INT2NUM(start_index), INT2NUM(next_index), 1);
            node_class_args[0] = input;
            node_class_args[1] = interval;
            node_class_args[2] = results;
            node_class_args[3] = results;
            
            return rb_class_new_instance(4, node_class_args, node_class);
          }
        C
      end
    end
  end
end