03-K64 Compiler
===============

This project involves building a compiler in Ruby, with the eventual goal of taking a custom grammar and converting it to machine code.

The grammer currently being used: http://www.labouseur.com/courses/compilers/grammar.pdf


The Lexer as well as the Parser are currently finished, with Semantic Analysis being currently smuggled into the system.



To run the compiler, run this command in the terminal:

$ ruby main.rb name_of_test_file

ex: $ ruby main.rb Test/test1.txt 



Pre-made test cases can be found in the ./Test/ folder. File names beginning with 'Y' will be successful, and file names that begin in 'N' will not.
