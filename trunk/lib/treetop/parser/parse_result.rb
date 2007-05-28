module Treetop
  class ParseResult
    attr_reader :nested_failures
    
    def initialize(nested_results = [])
      @nested_failures = collect_nested_failures_at_maximum_index(nested_results)
    end
    
    if !OPTIMIZE
      def collect_nested_failures_at_maximum_index(results)
        maximum_index = 0
        nested_failures = []
      
        results.each do |result|
          next if result.nested_failures.empty?
          index_of_nested_failures = result.nested_failures.first.index
          if index_of_nested_failures > maximum_index
            maximum_index = index_of_nested_failures
            nested_failures = result.nested_failures
          elsif index_of_nested_failures == maximum_index
            nested_failures += result.nested_failures
          end
        end
      
        return nested_failures
      end
    else
      inline do |builder|
        builder.c <<-C
          VALUE collect_nested_failures_at_maximum_index(VALUE results) {
            int i, j, current_index;

            VALUE current_nested_failures;
            int current_nested_failures_length;
            VALUE *current_nested_failures_ptr;

            VALUE nested_failures = rb_ary_new();
            
            int results_length = RARRAY_LEN(results);
            VALUE *results_ptr = RARRAY_PTR(results);
  
            int id_nested_failures = rb_intern("nested_failures");
            int id_index = rb_intern("index");
            
            int maximum_index = 0;

            for (i = 0; i < results_length; i++) {
              current_nested_failures = rb_funcall(results_ptr[i], id_nested_failures, 0);                                          
              current_nested_failures_length = RARRAY_LEN(current_nested_failures);              

              if (RARRAY_LEN(current_nested_failures) == 0) continue;
                
              current_nested_failures_ptr = RARRAY_PTR(current_nested_failures);
              current_index = NUM2INT(rb_funcall(current_nested_failures_ptr[0], id_index, 0));
              if (current_index > maximum_index) {
                maximum_index = current_index;
                nested_failures = current_nested_failures;
              } else if (current_index == maximum_index) {
                for (j = 0; j < current_nested_failures_length; j++) {
                  rb_ary_push(nested_failures, current_nested_failures_ptr[j]);
                }
              }
            }
            return nested_failures;
          }
        C
      end
      
    end
      

  end
end