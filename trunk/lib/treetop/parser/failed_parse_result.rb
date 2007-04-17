module Treetop
  class FailedParseResult < ParseResult
    def success?
      false
    end
    
    def failure?
      true
    end
  end
end