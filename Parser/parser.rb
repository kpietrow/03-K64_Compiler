#!/usr/bin/env ruby
# Building the CST
 

# Set up a class for unexpected tokens
class FaultyTokenError < StandardError 
	def initialize(e_token, r_token, lineno, pos)
		puts "ERROR: Expected an #{e_token}, received an #{r_token} at Line #{lineno} Position #{pos}"
		exit
	end
end
	
# retrieves the next token
def t_next (index, tokens)
	return tokens[index + 1]
end



def parser (tokens)
	
	index = 0
	if tokens.length == 1
		raise FaultyTokenError("Non T_EOFSIGN", tokens[0].type, tokens[0].lineno, tokens[0].pos)
	end	
	
	cst = block(index, tokens)
	
end

##
# Block ::== { StatementList }
#
def block (index, tokens)
	puts "Token Found"
	puts "\tExpectin' an T_LBRACE..."
	
	# Confirm '{' token
	if tokens[index].type == "T_LBRACE"
		puts "\t\tT_LBRACE found!"
		
	# Else yell at operator
	else 
		puts raise FaultyTokenError("T_LBRACE", tokens[index].type, tokens[index].lineno, tokens[index].pos)
	end
	
	# Confirm that there is a statement list, then go
	if t_next(index, tokens) =! "T_RBRACE"
		index = index + 1
		result = statement_list (index, tokens)
	
	# elsif return blank block
	
	end
	
	
end

##
# StatementList ::== Statement StatementList
#				::== Ɛ
#
def statement_list
	puts "Expects Statement"
	
end

##
# Statement ::== Print
#			::== Assignment
#			::== Var Declaration
#			::== While
#			::== If
#			::== Block
#
def statement (index, token, tokens)
	
	
end

##
# Print ::== print ( Expr )
#
def print
	
end

##
# Assignment ::== Id = Expr
#
def assignment
	
	
end

##
# VarDec ::== type Id
#
def vardec
	
	
end

##
# While ::== while Boolean Block
#
def while
	
	
end

##
# If ::== if Boolean Block
#
def if_statement

end

##
# Expr	::== IntExpr
# 		::== StringExpr
#		::== BooleanExpr
#		::== Id
#
def expr
	
	
end

##
# IntExpr 	::== digit intop Expr
#			::== digit
#
def intexpr
	
	
end

##
# StringExpr ::== " CharList "
#
def stringexpr
	
	
end

##
# BooleanExpr 	::== ( expr boolop Expr )
#				::== boolval
#
def boolexpr
	
	
end

##
# Id ::== char
#
def id
	
	
end

##
# CharList	::== char CharList
#			::== space CharList
#			::== Ɛ
#
def charList
	
	
end

##
# type	::== int | string | boolean
#
def type
	
	
end

##
# char	::== [a-z]
#
def char
	
	
end

##
# space	::== space
#
def space
	
	
end

##
# digit	::== [0-9]
#
def digit
	
	
end

##
# boolop ::== == | !=
#
def boolop
	
	
end

##
# boolean ::== false | true
#
def boolean
	
	
end

##
# intop ::== +
#
def intop
	
	
end