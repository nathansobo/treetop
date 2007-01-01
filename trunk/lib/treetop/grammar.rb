module Treetop
  class Grammar
    attr_accessor :root
    
    def initialize
      @parsing_rules = Hash.new
    end

    def new_parser
      Parser.new(self)
    end
    
    def add_parsing_rule(parsing_rule)
      @parsing_rules[parsing_rule.nonterminal_symbol.name] = parsing_rule
      self.root ||= parsing_rule.nonterminal_symbol
    end
    
    def get_parsing_expression(nonterminal_symbol)
      @parsing_rules[nonterminal_symbol.name].parsing_expression if @parsing_rules[nonterminal_symbol.name]
    end
  end
end