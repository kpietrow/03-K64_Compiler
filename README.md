03-K64 Compiler
===============

This project is a compiler, written in Ruby, that converts a simple grammer to 6502a instructions.

The grammer currently being used: https://drive.google.com/file/d/0B5JQ1YBMgVxnbUppX1EtNVJjQk0/edit?usp=sharing


As of now, the Lexer, Parser, Semantic Analysis, Tree Generation, and Code Generation are complete. Excellent!


To run the compiler, run this command in the terminal:

$ ruby main.rb name_of_test_file

ex: $ ruby main.rb Test/test1.txt 



Pre-made test cases can be found in the ./Test/ folder. File names beginning with 'Y' will be successful, and file names that begin in 'N' will not (or so is the hope).
