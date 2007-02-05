module Treetop
  class AnythingSymbol < TerminalSymbol
    def initialize
      super('^.')
      self.prefix_regex = /./
    end
  end
end