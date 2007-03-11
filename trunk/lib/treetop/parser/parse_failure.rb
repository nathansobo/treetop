module Treetop
  class ParseFailure
    attr_reader :index, :parsing_expression
    
    def initialize(index, parsing_expression)
      @index = index
      @parsing_expression = parsing_expression
    end
    
    def success?
      false
    end
    
    def failure?
      true
    end
    
    def interval
      index...index
    end
    
    def nested_terminal_failures
      nested_failures.collect(&:nested_terminal_failures).flatten.sort_by(&:index).reverse
    end
  end
end