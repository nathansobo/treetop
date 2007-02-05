module Treetop
  class PrimaryBuilder < ParsingExpressionBuilder
    def build
      choice(:terminal_symbol, :nonterminal_symbol)
    end
  end
end