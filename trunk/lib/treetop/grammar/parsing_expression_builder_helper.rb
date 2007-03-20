module ParsingExpressionBuilderHelper
  attr_accessor :grammar
  
  def nonterm(symbol)
    grammar.nonterminal_symbol(symbol)
  end
  
  def term(string)
    TerminalSymbol.new(string)
  end

  def exp(object, &block)
    exp = case object
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
    exp.node_class_eval &block if block
    exp
  end
  
  def any
    AnythingSymbol.new
  end
  
  def char_class(char_class_string)
    CharacterClass.new(char_class_string)
  end
  
  def andp(expression)
    exp(expression).and_predicate
  end
  
  def notp(expression)
    exp(expression).not_predicate
  end
  
  def optional(expression)
    exp(expression).optional
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

  def one_or_more(expression)
    exp(expression).one_or_more
  end

  def escaped(character)
    seq('\\', character)
  end

  def delimited_sequence_of_zero_or_more(expression, delimiter, &block)
    expression = exp(expression)
    delimiter = exp(delimiter)

    trailing_element = seq(delimiter, expression) do
      def value(grammar)
        elements[1].value(grammar)
      end
    end
    
    delimited_sequence = seq(optional(expression), zero_or_more(trailing_element)) do
      def element_values(grammar)
        if leading_element.nil?
          []
        else
          [leading_element_value(grammar)] + trailing_element_values(grammar)
        end
      end
      
      def leading_element_value(grammar)
        leading_element.value(grammar)
      end
      
      def trailing_element_values(grammar)
        trailing_elements.collect do |element|
          element.value(grammar)
        end
      end
      
      def leading_element
        elements[0]
      end
      
      def trailing_elements
        elements[1].elements
      end
    end
    
    delimited_sequence.node_class_eval &block if block
    return delimited_sequence
  end

  def delimited_sequence(expression, delimiter, &block)
    expression = exp(expression)
    delimiter = exp(delimiter)

    trailing_element = seq(delimiter, expression) do
      def value(grammar)
        elements[1].value(grammar)
      end
    end
    
    delimited_sequence = seq(expression, one_or_more(trailing_element)) do
      def element_values(grammar)
        [leading_element_value(grammar)] + trailing_element_values(grammar)
      end
      
      def leading_element_value(grammar)
        leading_element.value(grammar)
      end
      
      def trailing_element_values(grammar)
        trailing_elements.collect do |element|
          element.value(grammar)
        end
      end
      
      def leading_element
        elements[0]
      end
      
      def trailing_elements
        elements[1].elements
      end
    end
    
    delimited_sequence.node_class_eval &block if block
    return delimited_sequence
  end
end