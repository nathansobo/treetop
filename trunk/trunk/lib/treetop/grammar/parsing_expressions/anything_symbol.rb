module Treetop
  class AnythingSymbol < TerminalSymbol
    def initialize
      super('\A(.|\n)')
      self.prefix_regex = /\A(.|\n)/
    end
    
    def to_s
      '.'
    end
  end
end