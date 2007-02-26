module Treetop
  class ParseFailure
    attr_reader :index, :descriptors
    
    def initialize(index, *descriptors)
      @index = index
      @descriptors = descriptors
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
    
    def to_s
      expected_expressions = (descriptors.map {|desc| desc.expression.to_s}).join(" or ")
      return "Expected a prefix matching #{expected_expressions} at index #{index}."
    end
  end
end