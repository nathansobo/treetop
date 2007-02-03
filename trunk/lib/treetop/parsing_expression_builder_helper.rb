module ParsingExpressionBuilderHelper
  attr_accessor :grammar
  
  def nonterm(symbol)
    grammar.nonterminal_symbol(symbol)
  end
  
  def term(string)
    TerminalSymbol.new(string)
  end

  def exp(object)
    case object
    when String
      term(object)
    when Symbol
      nonterm(object)
    when ParsingExpression
      object
    when Array
      object.map { |elt| exp(elt) }
    else raise "Argument must be an instance of String, Symbol, or ParsingExpression"
    end
  end
  
  def any
    AnythingSymbol.new
  end
  
  def char_class(char_class_string)
    CharacterClass.new(char_class_string)
  end
  
  def notp(expression)
    exp(expression).not_predicate
  end
  
  def seq(*expressions, &block)
    sequence = Sequence.new(exp(expressions))
    sequence.node_class_eval &block if block
    return sequence
  end
  
  def choice(*expressions)
    OrderedChoice.new(exp(expressions))
  end
  
  def zero_or_more(expression)
    exp(expression).zero_or_more
  end
  
  def escaped(character)
    seq('\\', character)
  end
end