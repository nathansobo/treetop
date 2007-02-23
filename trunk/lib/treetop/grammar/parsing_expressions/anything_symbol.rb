module Treetop
  class AnythingSymbol < TerminalSymbol
    def initialize
      super('^.')
      self.prefix_regex = /./
    end
    
    def to_s
      '.'
    end
  end
end