#Using Treetop Grammars in Ruby
##Using the Command Line Compiler
You can `.treetop` files into Ruby source code with the `tt` command line script. `tt` takes an list of files with a `.treetop` extension and compiles them into `.rb` files of the same name. You can then `require` these files like any other Ruby script. Alternately, you can supply just one `.treetop` file and a `-o` flag to name specify the name of the output file. Improvements to this compilation script are welcome.

    tt foo.treetop bar.treetop
    tt foo.treetop -o foogrammar.rb

##Loading A Grammar Directly
The `Treetop.load` method takes the path to a `.treetop` file (where the extension is optional), and automatically compiles and evaluates the Ruby source. If you are getting errors in methods you define on the syntax tree, try using the command line compiler for better stack trace feedback. The need to do this is being addressed.

##Instantiating and Using Parsers
If a grammar by the name of `Foo` is defined, the compiled Ruby source will define a `FooParser` class. To parse input, create an instance and call its `parse` method with a string.

    Treetop.load "arithmetic"
    
    parser = ArithmeticParser.new
    puts parser.parse('1+1').success?
