#!/usr/bin/env ruby

###################################################
# This is the Parser of the 03-K64 Compiler.
# Crafted for Alan's 'Design Compilers' class,
# lovingly coded in Ruby magic, and narrated by
# her captain.
#
#
# Author: Kevin Pietrow
# Version: The shinier one
# 
# Note: Instructions for running the best compiler
# 		in the Verse can be found in the README
#
#




 
#################################################################
# Helper functions, Error declarations, Class declarations,
# and all of that shiny stuff
#

# Set up a class for unexpected $tokens
class FaultyTokenError < StandardError 
	def initialize(e_token, token)
		puts "\n-------------------------------------------------------------------"		
		puts "ERROR: Expected a '#{e_token}' token, but received a #{token.type} '#{token.value}' at Line: #{token.lineno} and Position: #{token.pos + 1}"
		puts "-------------------------------------------------------------------"
		exit
	end
end

# Set up a class for early Leaf nodes
class EarlyLeafError < StandardError
	def initialize(token)
		if token != nil
			puts "\n-------------------------------------------------------------------"		
			puts "ERROR: Received an early leaf token of #{token.type} '#{token.value}' at Line: #{token.lineno} and Position: #{token.pos + 1}"
			puts "-------------------------------------------------------------------"
			exit
		else
			puts "\n-------------------------------------------------------------------"		
			puts "ERROR: Received an early leaf token of 'nil'"
			puts "-------------------------------------------------------------------"
			exit
		end
	end
end




#################################################################
# Main function of the best gorram' parse tree in the Verse
#


# main function for this file
def parser (tokens)

	# create the new, concrete syntax tree
	# making it global to reduce headaches (hopefully XD )
	$cst = ConcreteSyntaxTree.new
	
	# define some other useful, global vars
	$tokens = tokens
	$index = 0
	
	# have to ask alan about this
	if $tokens.length <= 1
		puts "Insufficient code present! There is only #{$tokens.length} token here!"
		exit
	end	
	
	
	# Engine to full burn!!!
	#parse("Program", program)
	program
	
	
	begin
		if $tokens.length != $index
			raise EOFDetectionError.new("early", $tokens[$index - 1].lineno, $tokens[$index - 1].pos)
		end
	rescue EOFDetectionError
	end
		
	
	
	return $cst
end	
	
##########################################
# Helper functions
#

# retrieves the type of the current token
def scout_token 
	return $tokens[$index].type
end


# testing for a token match. name, expected, received
# match is also going to help us with our symbol table scope
def match_token (exp, token)
	puts "Leaf token received: #{token.value}"
	puts "\tExpecting token of type: #{exp}"

	if exp == token.type
		puts "\t\tShiny. Got #{token.type}!"
		$cst.add_leaf(token.value, token)
		
		# To try to make this auto-managed
		$index = $index + 1
		
	else
		raise FaultyTokenError.new(exp, token)
	end
end




###############################
# The all-important parser
# This will control the ascent and descent of the 
# nodes in the CST, and will help to structure the program
#
# NOTE: This method is currently deprecated
#
def parse (name_of_next_step, next_step)
	
	puts "----------" + name_of_next_step + "------------"
	
	$cst.add_branch(name_of_next_step)
	
	next_step
	
end


###############################
# Program ::== Block $
#
def program 
	
	$cst.add_branch("Program")
	
	block
	match_token("T_EOFSIGN", $tokens[$index])

end

###############################
# Block ::== { StatementList }
#
def block 
	
	$cst.add_branch("Block")
	
	match_token("T_LBRACE", $tokens[$index])
	statement_list
	match_token("T_RBRACE", $tokens[$index])
	
	$cst.ascend
	
end



###############################
# StatementList ::== Statement StatementList
#				::== Ɛ
#
def statement_list 
	
	$cst.add_branch("StatementList")
	
	# } indicates that the StatementList is finished
	if scout_token != "T_RBRACE"
		statement
		statement_list
	
	# handle an epsilon
	else
		$cst.add_leaf("Epsilon", nil)
	end
	
	$cst.ascend

end

###############################
# Statement ::== Print
#			::== Assignment
#			::== Var Declaration
#			::== While
#			::== If
#			::== Block
#
def statement 

	$cst.add_branch("Statement")

	case scout_token
	when "T_PRINT"
		print_stmt
	when "T_ID"
		assignment_stmt
	when "T_TYPE"
		vardecl
	when "T_WHILE"
		while_stmt
	when "T_IF"
		if_stmt
	when "T_LBRACE"
		block
	else
		raise FaultyTokenError.new("T_PRINT, T_ID, T_TYPE, T_WHILE, T_IF, or T_LBRACE", $tokens[$index])
	end
	
	$cst.ascend
	
end

###############################
# Print ::== print ( Expr )
#
def print_stmt 

	$cst.add_branch("PrintStatement")

	match_token("T_PRINT", $tokens[$index])
	match_token("T_LPAREN", $tokens[$index])
	expr
	match_token("T_RPAREN", $tokens[$index])
	
	$cst.ascend
	
end

###############################
# Assignment ::== Id = Expr
#
def assignment_stmt 
	
	$cst.add_branch("AssignmentStatement")
	
	id
	match_token("T_ASSIGNMENT", $tokens[$index])
	expr
	
	$cst.ascend

end

###############################
# VarDecl ::== type Id
#
def vardecl 
	
	$cst.add_branch("VarDecl")
	
	type
	id
	
	$cst.ascend

end

###############################
# While ::== while BooleanExpr Block
#
def while_stmt 
	
	$cst.add_branch("WhileStatement")
	
	match_token("T_WHILE", $tokens[$index])
	boolexpr
	block
	
	$cst.ascend
	
end

###############################
# If ::== if BooleanExpr Block
#
def if_stmt 
	
	$cst.add_branch("IfStatement")
	
	match_token("T_IF", $tokens[$index])
	boolexpr
	block
	
	$cst.ascend
	
end

###############################
# Expr	::== IntExpr
# 		::== StringExpr
#		::== BooleanExpr
#		::== Id
#
def expr 

	$cst.add_branch("Expr")
	
	case scout_token
	when "T_DIGIT"
		intexpr
	when "T_QUOTE"
		stringexpr
	when "T_LPAREN", "T_BOOLEAN"
		boolexpr
	when "T_ID"
		id
	else
		raise FaultyTokenError.new("T_DIGIT, T_QUOTE, T_LPAREN, or T_ID", $tokens[$index])
	end
	
	$cst.ascend
	
end

###############################
# IntExpr 	::== digit intop Expr
#			::== digit
#
def intexpr 

	$cst.add_branch("IntExpr")
	
	if $tokens[$index + 1].type == "T_PLUS"
		digit
		intop
		expr
	else
		digit
	end
	
	$cst.ascend

end

###############################
# StringExpr ::== " CharList "
#
def stringexpr 
	
	$cst.add_branch("StringExpr")
	
	match_token("T_QUOTE", $tokens[$index])
	charList
	match_token("T_QUOTE", $tokens[$index])

	$cst.ascend
	
end

###############################
# BooleanExpr 	::== ( Expr boolop Expr )
#				::== boolval
#
def boolexpr 

	$cst.add_branch("BooleanExpr")
	
	if $tokens[$index].type == "T_LPAREN"
		match_token("T_LPAREN", $tokens[$index])
		expr
		boolop
		expr
		match_token("T_RPAREN", $tokens[$index])
	else
		boolval
	end
	
	$cst.ascend

end

###############################
# Id ::== char
#
def id 
	
	$cst.add_branch("Id")
	
	char
	
	$cst.ascend

end

###############################
# CharList	::== char CharList
#			::== space CharList
#			::== Ɛ
#
def charList 

	$cst.add_branch("CharList")
	
	# because we've already taken care of string formation
	# in the lexer
	match_token("T_STRING", $tokens[$index])

	$cst.ascend

end

###############################
# type	::== int | string | boolean
#
def type 
	
	$cst.add_branch("type")
	
	match_token("T_TYPE", $tokens[$index])
	
	$cst.ascend
end

###############################
# char	::== [a-z]
#
def char 
	
	$cst.add_branch("char")
	
	# We know that strings have already been taken care of,
	# so these can only be id's
	match_token("T_ID", $tokens[$index])
	
	$cst.ascend
	
end

###############################
# space	::== space
#
# Only necessary in strings, which have already
# been taken care of
#
# def space 
# end

###############################
# digit	::== [0-9]
#
def digit 
	
	$cst.add_branch("digit")
	
	match_token("T_DIGIT", $tokens[$index])
	
	$cst.ascend
	
end

###############################
# boolop ::== == | !=
#
def boolop 
	
	$cst.add_branch("boolop")
	
	match_token("T_BOOLOP", $tokens[$index])
	
	$cst.ascend

end

###############################
# boolean ::== false | true
#
def boolval 

	$cst.add_branch("boolval")

	match_token("T_BOOLEAN", $tokens[$index])
	
	$cst.ascend

end

###############################
# intop ::== +
#
def intop 

	$cst.add_branch("intop")

	match_token("T_PLUS", $tokens[$index])
	
	$cst.ascend

end
