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
	if tokens.length > 1
		block(index, tokens)
	#elsif
		#raise error
	end	
	
end

##
# Block ::== { StatementList }
#
def block
	puts "Token Found"
	puts "\tExpectin' an T_LBRACE..."
	
	if tokens[0].type
	
	
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