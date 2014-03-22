#!/usr/bin/env ruby

###################################################
# This is the Parser of the 03-K64 Compiler.
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
#




 
#################################################################
# Helper functions, Error declarations, Class declarations,
# and all of that shiny stuff
#

# Set up a class for unexpected $tokens
class FaultyTokenError < StandardError 
	def initialize(e_token, token)
		puts "\n-------------------------------------------------------------------"		
		puts "ERROR: Expected a '#{e_token}' token, but received a #{token.type} '#{token.value}' at Line: #{token.lineno} at about Position: #{token.pos + 1}"
		puts "-------------------------------------------------------------------"
		exit
	end
end
	

# CST tree class
class CST
	
	attr_reader :current
	
	@@total_nodes = 0
	@root = nil
	@current = nil
	
	
	def initialize ()
		@root = nil
		@current = nil
	end
	
	# add a node
	def add_node (name, token = nil)
		@@total_nodes = @@total_nodes + 1
		
		# if there are no nodes yet, start it off!
		if @root == nil
			@root = Node.new(name, token, nil)
			@current = @root
		
		# otherwise, move about this intelligently
		else
			@current = @current.add_child(name, token)
		end
	end
	
	def ascend ()
		
		# just want to be careful
		if @current != @root
			@current = @current.parent
		end
		
	end
	
	# Prints out the very basic details of the CST
	def raw_print ()
		
		puts "The nodes in the constructed CST, going from lower left to upper right\n(Note: terminal nodes will be operators, or pure uppercase chars):"
		
		def child_loop (children)
			children.cycle(1) { |child|
				if child.children.length > 0
					child_loop(child.children)
				else
					print "  ||  " + child.name
				end
			}
		end
		
		print @root.name
		child_loop(@root.children)
		
	end
	
end

# Class for nodes on the syntax trees
class Node
	attr_reader :total_id, :id, :token, :name
	attr_accessor :parent, :children
	
	@@total_id = 0
	@id = nil
	@name = nil
	@token = nil
	@children = []
	@parent = nil
	
	def initialize (name, token = nil, parent = nil)
		@@total_id = @@total_id + 1
		@id = @@total_id
		@name = name
		@token = token
		@parent = parent
		@children = []
	end
	
	# add child, set child's parent
	def add_child (child, token = nil)
		new_node = Node.new(child, token, self)
		@children.push(new_node)
		return new_node
	end
	
	# add parent
	def add_parent (parent)
		@parent = parent
	end
	
end




#################################################################
# Main function of the best gorram' parse tree in the Verse
#


# main function for this file
def parser (tokens)

	# create the new, concrete syntax tree
	# making it global to reduce headaches (hopefully XD )
	$cst = CST.new()
	
	# define some other useful, global vars
	$tokens = tokens
	$index = 0
	$symbol_tbl = SymbolTable.new()
	
	# have to ask alan about this
	if $tokens.length <= 1
		puts "Insufficient code present! There is only #{$tokens.length} token here!"
		exit
	end	
	
	
	# Engine to full burn!!!
	parse("Program", program())
	
	return $cst, $symbol_tbl
end	
	
##########################################
# Helper functions
#

# retrieves the type of the current token
def scout_token ()
	return $tokens[$index].type
end


# testing for a token match. name, expected, received
# match is also going to help us with our symbol table scope
def match_token (name, exp, token)
	puts "Leaf token received: #{token.value}"
	puts "\tExpecting token of type: #{exp}"

	if exp == token.type
		puts "\t\tShiny. Got #{token.type}!"
		$cst.add_node(name, token)
		
		# manage the symbol table here
		if token.type == "T_LBRACE"
			$symbol_tbl.enter()
		elsif token.type == "T_RBRACE"
			$symbol_tbl.exit()
		end
		
		
		# To try to make this auto-managed
		$index = $index + 1
		
		# Because a match_token only occurs for a leaf/terminal token
		$cst.ascend()
	else
		raise FaultyTokenError.new(exp, token)
	end
end




###############################
# The all-important parser
# This will control the ascent and descent of the 
# nodes in the CST, and will help to structure the program
#
def parse (name_next_step, next_step)
	
	$cst.add_node(name_next_step)
	
	next_step
	
	$cst.ascend()
	
end


###############################
# Program ::== Block $
#
def program ()
	
	parse("Block", block())
	match_token("$", "T_EOFSIGN", $tokens[$index])

end

###############################
# Block ::== { StatementList }
#
def block ()
	
	match_token("{", "T_LBRACE", $tokens[$index])
	parse("StatementList", statement_list())
	match_token("}", "T_RBRACE", $tokens[$index])
	
end



###############################
# StatementList ::== Statement StatementList
#				::== Ɛ
#
def statement_list ()

	# } indicates that the StatementList is finished
	if scout_token() != "T_RBRACE"
		parse("Statement", statement())
		parse("StatementList", statement_list())
	
	# handle an epsilon
	else
		$cst.add_node("Epsilon")
		$cst.ascend()
	end

end

###############################
# Statement ::== Print
#			::== Assignment
#			::== Var Declaration
#			::== While
#			::== If
#			::== Block
#
def statement ()

	case scout_token()
	when "T_PRINT"
		parse("PrintStatement", print_stmt())
	when "T_ID"
		parse("AssignmentStatement", assignment_stmt())
	when "T_TYPE"
		parse("VarDecl", vardecl())
	when "T_WHILE"
		parse("WhileStatement", while_stmt())
	when "T_IF"
		parse("IfStatement", if_stmt())
	when "T_LBRACE"
		parse("Block", block())
	else
		raise FaultyTokenError.new("T_PRINT, T_ID, T_TYPE, T_WHILE, T_IF, or T_LBRACE", $tokens[$index])
	end
	
end

###############################
# Print ::== print ( Expr )
#
def print_stmt ()

	match_token("PRINT", "T_PRINT", $tokens[$index])
	match_token("(", "T_LPAREN", $tokens[$index])
	parse("Expr", expr())
	match_token(")", "T_RPAREN", $tokens[$index])
	
end

###############################
# Assignment ::== Id = Expr
#
def assignment_stmt ()
	
	parse("Id", id())
	match_token("=", "T_ASSIGNMENT", $tokens[$index])
	parse("Expr", expr())

end

###############################
# VarDecl ::== type Id
#
def vardecl ()
	
	# Add the var decl to the symbol table
	$symbol_tbl.add_symbol($tokens[$index].value, $tokens[$index + 1].value)
	
	parse("type", type())
	parse("Id", id())

end

###############################
# While ::== while BooleanExpr Block
#
def while_stmt ()
	
	match_token("WHILE", "T_WHILE", $tokens[$index])
	parse("BooleanExpr", boolexpr())
	parse("Block", block())
	
end

###############################
# If ::== if BooleanExpr Block
#
def if_stmt ()
	
	match_token("IF", "T_IF", $tokens[$index])
	parse("BooleanExpr", boolexpr())
	parse("Block", block())
	
end

###############################
# Expr	::== IntExpr
# 		::== StringExpr
#		::== BooleanExpr
#		::== Id
#
def expr ()
	
	case scout_token()
	when "T_DIGIT"
		parse("IntExpr", intexpr())
	when "T_QUOTE"
		parse("StringExpr", stringexpr())
	when "T_LPAREN", "T_BOOLEAN"
		parse("BooleanExpr", boolexpr())
	when "T_ID"
		parse("Id", id())
	else
		raise FaultyTokenError.new("T_DIGIT, T_QUOTE, T_LPAREN, or T_ID", $tokens[$index])
	end
	
end

###############################
# IntExpr 	::== digit intop Expr
#			::== digit
#
def intexpr ()
	
	if $tokens[$index + 1].type == "T_PLUS"
		parse("digit", digit())
		parse("intop", intop())
		parse("Expr", expr())
	else
		parse("digit", digit())
	end

end

###############################
# StringExpr ::== " CharList "
#
def stringexpr ()
	
	match_token('"', "T_QUOTE", $tokens[$index])
	parse("CharList", charList())
	match_token('"', "T_QUOTE", $tokens[$index])

end

###############################
# BooleanExpr 	::== ( Expr boolop Expr )
#				::== boolval
#
def boolexpr ()
	
	if $tokens[$index].type == "T_LPAREN"
		match_token("(", "T_LPAREN", $tokens[$index])
		parse("Expr", expr())
		parse("boolop", boolop())
		parse("Expr", expr())
		match_token(")", "T_RPAREN", $tokens[$index])
	else
		parse("boolval", boolval())
	end

end

###############################
# Id ::== char
#
def id ()
	
	parse("char", char())

end

###############################
# CharList	::== char CharList
#			::== space CharList
#			::== Ɛ
#
def charList ()
	
	# because we've already taken care of string formation
	# in the lexer
	match_token("STRING", "T_STRING", $tokens[$index])

end

###############################
# type	::== int | string | boolean
#
def type ()
	
	match_token("TYPE", "T_TYPE", $tokens[$index])
	
end

###############################
# char	::== [a-z]
#
def char ()
	
	# We know that strings have already been taken care of,
	# so these can only be id's
	match_token("ID", "T_ID", $tokens[$index])

end

###############################
# space	::== space
#
# Only necessary in strings, which have already
# been taken care of
#
# def space ()
# end

###############################
# digit	::== [0-9]
#
def digit ()
	
	match_token("DIGIT", "T_DIGIT", $tokens[$index])
	
end

###############################
# boolop ::== == | !=
#
def boolop ()
	
	match_token("BOOLOP", "T_BOOLOP", $tokens[$index])

end

###############################
# boolean ::== false | true
#
def boolval ()

	match_token("BOOLEAN", "T_BOOLEAN", $tokens[$index])

end

###############################
# intop ::== +
#
def intop ()

	match_token("PLUS", "T_PLUS", $tokens[$index])

end
