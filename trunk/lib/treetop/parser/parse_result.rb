module Treetop
  class ParseResult
    attr_reader :nested_failures
    
    def initialize(nested_failures = [])
      @nested_failures = nested_failures
    end
  end
end