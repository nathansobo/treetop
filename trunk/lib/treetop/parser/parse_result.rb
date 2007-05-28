module Treetop
  class ParseResult
    attr_reader :nested_failures
    
    def initialize(nested_failures = [])
      @nested_failures = select_failures_at_maximum_index(nested_failures)
    end
    
    protected
    if !OPTIMIZE
      def select_failures_at_maximum_index(failures)
        maximum_index = 0
        failures_at_maximum_index = []
      
        failures.each do |failure|
          if failure.index > maximum_index
            failures_at_maximum_index = [failure]
            maximum_index = failure.index
          elsif failure.index == maximum_index
            failures_at_maximum_index << failure
          end
        end
      
        return failures_at_maximum_index
      end
    else
      inline do |builder|
        builder.c <<-EOC
          VALUE select_failures_at_maximum_index(VALUE failures) {
            int i, current_failure_index;
            int maximum_index = 0;

            int failures_length = RARRAY(failures)->len;
            VALUE *failures_ptr = RARRAY(failures)->ptr;

            int id_push = rb_intern("push");
            int id_clear = rb_intern("clear");
            int id_index = rb_intern("index");
            VALUE failures_at_maximum_index = rb_ary_new();

            for (i = 0; i < failures_length; i++) {
              current_failure_index = NUM2INT(rb_funcall(failures_ptr[i], id_index, 0));
              if (current_failure_index > maximum_index) {
                maximum_index = current_failure_index;
                rb_funcall(failures_at_maximum_index, id_clear, 0);
                rb_funcall(failures_at_maximum_index, id_push, 1, failures_ptr[i]);
              } else if (current_failure_index == maximum_index) {
                rb_funcall(failures_at_maximum_index, id_push, 1, failures_ptr[i]);
              }
            }
            return failures_at_maximum_index;
          }
        EOC
      end
    end
  end
end