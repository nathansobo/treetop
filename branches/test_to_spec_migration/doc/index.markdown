<p class="intro_text">
	
Treetop is a language for describing languages. Combining the elegance of Ruby with cutting-edge <em>parsing expression grammars</em>, it helps you analyze syntax with revolutionarily ease.	

</p>


#Intuitive Grammar Specifications
Treetop's packrat parsers use _memoization_ to make the backtracking possible in linear time. This cuts the gordian knot of grammar design. There's no need to look ahead and no need to lex. Worry about the structure of the language, not the idiosyncrasies of the parser.

#Syntax-Oriented Programming
Rather than implementing semantic actions that construct parse trees, define methods on the trees that Treetop automatically constructs–and write this code directly inside the grammar.

#Reusable, Composable Language Descriptions
Break grammars into modules and compose them via Ruby's mixin semantics. Or combine grammars written by others in novel ways. Or extend existing grammars with your own syntactic constructs by overriding rules with access to a `super` keyword. Compositionally means your investment of time into grammar writing is secure–you can always extend and reuse your code.

#Acknowledgements
First, thank you to my employer Rob Mee of Pivotal Labs for funding a substantial portion of Treetop's development. He gets it.

I'd also like to thank:

* Damon McCormick for several hours of pair programming.
* Nick Kallen for lots of well-considered feedback and a few afternoons of programming.
* Brian Takita for a night of pair programming.
* Eliot Miranda for urging me rewrite as a compiler right away rather than putting it off.
* Ryan Davis and Eric Hodel for hurting my code.
* Dav Yaginuma for kicking me into action on my idea.
* Bryan Ford for his seminal work on Packrat Parsers.
* The editors of Lambda the Ultimate, where I discovered parsing expression grammars.