#!/usr/bin/env ruby


###################################################
# This is the tokenizer of the 03-K64 Compiler.
# Crafted for Alan's 'Design Compilers' class,
# lovingly coded in Ruby magic, and narrated by
# her captain.
#
#
# Author: Kevin Pietrow
# Version: The shiny one
# 
# Note: Instructions for running the best compiler
# 		in the Verse can be found in the README
#



###################################################
# Establishin' the Token class we will be using to 
# store our nice, legal, tokens in
#
#

class Token
	# Establishin' a token class for easier categorization
	
	attr_accessor :type, :value, :lineno, :pos
	
	def initialize(type, value, lineno, pos)
		@type, @value, @lineno, @pos = type, value, lineno, pos
	end
end



###################################################
# Here, inside the main tokenize() method, we've 
# sorted out the different tokenizing methods
# for the various types we can encounter: operators, 
# strings, and alphanumerics
#

# take in the potential token, type (char/op), lineno, and pos
def tokenize (p_token, type, lineno, pos)

	puts "HEYYYYYYYYYY: " + p_token
	
	if type == "op"
		return op_tokenize(p_token, lineno, pos)
	
	elsif type == "character"
		return char_tokenize(p_token, lineno, pos)
	
	elsif type == "string"
		return string_tokenize(p_token, lineno, pos)
	
	elsif type == "digit"
		return digit_tokenize(p_token, lineno, pos)
	
	else
		puts "NOOOOOO"
		# should create an error here, just for thoroughness
	end
end



# examine for potential as an operator token
def op_tokenize (p_token, lineno, pos)

	puts "OPPPPPPPPPPPPP"
	case p_token
	when "="
		return Token.new("T_ASSIGNMENT", p_token, lineno, pos)
	when "{"
		return Token.new("T_LBRACE", p_token, lineno, pos)
	when "}"
		return Token.new("T_RBRACE", p_token, lineno, pos)
	when "("
		return Token.new("T_LPAREN", p_token, lineno, pos)
	when ")"
		return Token.new("T_RPAREN", p_token, lineno, pos)
	when "\""
		return Token.new("T_QUOTE", p_token, lineno, pos)
	when "=="
		return Token.new("T_BOOLOP", p_token, lineno, pos)
	when "!="
		return Token.new("T_BOOLOP", p_token, lineno, pos)
	when "+"
		return Token.new("T_PLUS", p_token, lineno, pos)
	when "$"
		return Token.new("T_EOFSIGN", p_token, lineno, pos)
	else
		raise UnknownSymbolError.new(p_token, lineno, pos)
	end
end


# dealing with strings
def string_tokenize(p_token, lineno, pos)

	puts "STRINGGGGGGGGGGG"

	# the thinking behind this is that the string has already been 
	# checked for and validated in the Lexer. This method being in 
	# tokenizer.rb is to ensure consistency in the realm of token generation
	#
	# The validation process may move here in the future	
	return Token.new("T_STRING", p_token, lineno, pos)
end



# dealing with alphanumeric character strings
def char_tokenize(p_token, lineno, pos)

	puts "CHARRRRRRRRRRRR"

	# could be a KEYWORD, TYPE, or ID here
	case p_token
	when /\b(while)\b/
		return Token.new("T_WHILE", p_token, lineno, pos)
	when /\b(if)\b/
		return Token.new("T_IF", p_token, lineno, pos)
	when /\b(false)\b/
		return Token.new("T_BOOLEAN", p_token, lineno, pos)
	when /\b(true)\b/
		return Token.new("T_BOOLEAN", p_token, lineno, pos)
	when /\b(print)\b/
		return Token.new("T_PRINT", p_token, lineno, pos)
	when /\b(int)\b/
		return Token.new("T_TYPE", p_token, lineno, pos)
	when /\b(string)\b/
		return Token.new("T_TYPE", p_token, lineno, pos)
	when /\b(boolean)\b/
		return Token.new("T_TYPE", p_token, lineno, pos)
	when /[a-z]+/
		return Token.new("T_ID", p_token, lineno, pos)
	else
		raise UnknownSymbolError.new(p_token, lineno, pos)
	end
	
end


# digit time
def digit_tokenize(p_token, lineno, pos)

	puts "DIGITTTTTTTTTTT"
	
	# just check digit length
	if p_token.length == 1
		return Token.new("T_DIGIT", p_token, lineno, pos)
	else
		raise UnknownSymbolError.new(p_token, lineno, pos)
	end
	
end
