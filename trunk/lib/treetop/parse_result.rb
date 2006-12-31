module Treetop
  class ParseResult
    attr_reader  :value, :start_index, :end_index
    attr_writer :failure
  
    def self.new_failure(next_index)
      result = self.new(nil, nil, next_index)
      result.failure = true
      result
    end
  
    def initialize(value, start_index, end_index)
      self.failure = false
      @value = value
      @start_index = start_index
      @end_index = end_index
    end
  
    def failure?
      @failure
    end
  end
end