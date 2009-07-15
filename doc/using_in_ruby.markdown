#Using Treetop Grammars in Ruby
##Using the Command Line Compiler
You can `.treetop` files into Ruby source code with the `tt` command line script. `tt` takes an list of files with a `.treetop` extension and compiles them into `.rb` files of the same name. You can then `require` these files like any other Ruby script. Alternately, you can supply just one `.treetop` file and a `-o` flag to name specify the name of the output file. Improvements to this compilation script are welcome.

    tt foo.treetop bar.treetop
    tt foo.treetop -o foogrammar.rb

##Loading A Grammar Directly
The Polyglot gem makes it possible to load `.treetop` or `.tt` files directly with `require`. This will invoke `Treetop.load`, which automatically compiles the grammar to Ruby and then evaluates the Ruby source. If you are getting errors in methods you define on the syntax tree, try using the command line compiler for better stack trace feedback. A better solution to this issue is in the works.

##Instantiating and Using Parsers
If a grammar by the name of `Foo` is defined, the compiled Ruby source will define a `FooParser` class. To parse input, create an instance and call its `parse` method with a string. The parser will return the syntax tree of the match or `nil` if there is a failure.

    Treetop.load "arithmetic"
    
    parser = ArithmeticParser.new
    if parser.parse('1+1')
      puts 'success'
    else
      puts 'failure'
    end

##Defining Grammars Directly in Ruby
It is possible to define parser directly in Ruby source file.

###Grammars
Defining parsers in Ruby code is as much similar to original definition as it is possible. To create a grammar just write:

    include Treetop::Syntax
    grammar :Foo do
    end
    parser = FooParser.new

Treetop will automatically compile and load it into memory, thus an instance of `FooParser` can be created.

###Syntactic Recognition
To create a rule inside of a grammar simply write:

    include Treetop::Syntax
    grammar :Foo do
      rule :bar do
        ...
      end
    end

Inside the rule any of Treetop syntactic elements can be used. Each element of a rule is created with standard Ruby classes: Strings act as Terminals, Symbols stand for Nonterminals, Arrays are sequences, Regexps are character classes.

_Note: it is better not to use Numbers, as terminal symbols; use Strings instead._

Sequences can be defined as follows:

    rule :sequence do
      [ "foo", "bar", "baz" ]
    end

Ordered choices use `/` operator:

    rule :choice do
      "foo" / "bar"
    end

Sequences have higher precedence than choices, so choices must be parenthesized to be used as the elements of a sequence. For example:

    rule :nested do
      ["foo", "bar", "baz" / "bop" ]    # -> "foo" "bar" ( "baz" / "bop" )
    end

Special operators like `!`, `&`, `?`, `+` and `*` are available through methods (all of the methods return element itself so calls can be chained) of elements in a rule:

    Op. | Method
    -----------
     !  | bang
     &  | amper
     ?  | mark
     +  | plus
     *  | kleene

For example grammar:

    grammar :Foo do
      rule :bar do
       [ "baz" / "bop" ].kleene
      end
    end

can generate any word that contain words "bar" and "bop".

###Semantic Interpretation

Syntax node declaration can be added by `node` method (which may be called the same as operators above):

    grammar :Parens do
      rule :parenthesized_letter do
        ([ '(', :parenthesized_letter, ')'] / /[a-z]/ ).node(:ParenNode)
      end
    end
    
It is also possible to add inline blocks of code. They are in fact strings strictly inserted into generated grammar:

    grammar :Parens do
      rule :parenthesized_letter do
        (['(', :parenthesized_letter, ')'] / /[a-z]/ ).block(%{
          def depth
            if nonterminal?
              parenthesized_letter.depth + 1
            else
              0
            end
          end
        })
      end
    end

Labels in rule definitions can be written as follow (example taken from documentation):

  rule :labels do
    [/[a-z]/.label(:first_letter), [', ', /[a-z]/.kleene.label(:letter)].label(:rest_letters)].block(%{
      ...
    })
  end

###Composition

Inclusion of a grammar works thanks to `include` function call inside the grammar definition:

    grammar :One do
      rule :a do
        foo"
      end
    
      rule :b do        
        "baz"
      end      
    end

    grammar :Two do
      include :One
      rule :a do      
        :super / "bar" / :c
      end
      
      rule :c do
       :b      
      end
    end

Grammar Two can generate `"foo"`, `"bar"` and `"baz"` words.
