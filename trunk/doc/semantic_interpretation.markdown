#Semantic Interpretation
Parsers produce trees corresponding to the expressions matched during the parse. For each expression match, an instance of `Treetop::Runtime::SyntaxNode` is instantiated to represent the corresponding node in the tree. Methods can be added to these nodes by following parsing expressions with curly-brace (`{}`) delimited block. You can think about each parsing expression as a kind of class declaration. Following the expression with a block gives the "class" it declares a body.

    grammar ParenLanguage
      rule parenthesized_letter
        '(' parenthesized_letter ')' {
          def depth
            parenthesized_letter.depth + 1
          end
        }
        /
        [a-z] {
          def depth
            0
          end
        }
      end
    end
    
The above grammar matches nested parentheses surrounding a lower-cased letter from a to z. Each alternative expression is followed by a block with a method definition.