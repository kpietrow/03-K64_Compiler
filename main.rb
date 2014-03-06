#!/usr/bin/env ruby

# central file

require 'io/console'

require './Lexer/lexer.rb'
require './SymbolTable/symbol_table.rb'

# bring in tokenizing functions
require './Lexer/tokenizer.rb'

require './Parser/parser.rb'

class BlankFileError < StandardError
	def initialize()
		puts "ERROR: There don't seem to be any information in that here file. We're just gonna exit the program for ye."
		exit
	end
end


##
# Setting up global regex variables
# Settin' up some basic regex searches now
$digit = /[0-9]/
$alpha_numeric = /[a-z0-9]/

$character = /[a-z]/
$space = /\s/
$eof = /\$/

#token_list = ["T_ASSIGNMENT", "T_LBRACE", "T_RBRACE", "T_LPAREN", 
#				"T_RPAREN", "T_QUOTE", "T_EQUALTO", "T_NOTEQUAL", "T_PLUS", 
#					"T_EOFSIGN", "T_IF", "T_WHILE", "T_BOOLEAN", "T_STRING", 
#						"T_ID", "T_DIGIT", "T_PRINT", "T_TYPE"]

# note, this here includes whitespace, so be careful about where it's used
$operator = /\W/


def main
# He's going to be runnin' this here operation
	
	# Retrieving that shiny input file
	input_file = File.new(ARGV[0])
	
	# Sortin' out them good lines from the bad
	input_file = IO.readlines(input_file)
	
	if input_file.length == 0
		raise BlankFileError
	end
	
	token_stream = lexer(input_file)
	for i in token_stream
		print i.type
		print ", "
	end
	
	puts "\n\n"
	
	for i in s_table
		print i
	end
	
	parsed_stream = parser(token_stream)
end

main