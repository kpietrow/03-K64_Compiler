03-K64 Compiler
===============

This project involves building a compiler in Ruby, with the eventual goal of taking a custom grammar and converting it to machine code.

The grammer currently being used: http://www.labouseur.com/courses/compilers/grammar.pdf


As of now, the Lexer, Parser, Semantic Analysis, Tree Generation, and (most of) Code Generation is complete. Excellent!


To run the compiler, run this command in the terminal:

$ ruby main.rb name_of_test_file

ex: $ ruby main.rb Test/test1.txt 



Pre-made test cases can be found in the ./Test/ folder. File names beginning with 'Y' will be successful, and file names that begin in 'N' will not (or so I hope).
