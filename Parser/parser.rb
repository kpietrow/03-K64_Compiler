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





# TODO: Should probably set it so that there's a function 
# which takes care of parsing output
 
#################################################################
# Helper functions, Error declarations, Class declarations,
# and all of that shiny stuff
#

# Set up a class for unexpected $tokens
class FaultyTokenError < StandardError 
	def initialize(known, e_token, token)
		if known		
			puts "ERROR: Expected a(n) #{e_token} token, received a(n) #{token.type} at Line #{token.lineno} Position #{token.pos}"
			exit
		else
			puts "ERROR: Incorrect token received, received a(n) #{token.type} at Line #{token.lineno} Position #{token.pos}"
			exit
		end
	end
end
	

# tentative class of a tree
class CST
	
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
end

# tentative class for nodes on the tree
class Node
	attr_reader :total_id, :id, :token
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
		new_node = Scope.new(child, token, self)
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
	$symbol_tbl = SymbolTbl.new()
	
	# have to ask alan about this
	if $tokens.length <= 1
		puts "Insufficient code present! There is only #{$tokens.length} token here!"
		exit
	end	
	
	
	# Engine to full burn!!!
	parse("Program", program())
	
	##########################################
	# Helper functions
	#
	
	# retrieves the type of the current token
	def scout_token ()
		return $tokens[$index].type
	end


	# testing for a token match. name, expected, received
	def match_token (name, exp, token)
		puts "Leaf token received: #{token.value}"
		puts "\nExpecting token of type: #{exp}"
	
		if exp == rec
			puts "\n\nShiny. Got #{token.type}!"
			$cst.add_node(name, token)
			
			# To try to make this auto-managed
			$index = $index + 1
			
			# Because a match_token only occurs for a leaf/terminal token
			$cst.ascend()
		else
			raise FaultyTokenError.new(true, exp, token)
		end
	end
	
	
	
	
	###############################
	# The all-important parser
	# This will control the ascent and descent of the 
	# nodes in the CST, and will help to structure the program
	#
	def parse (name_next_step, next_step)
		$cst.add_node(name_next_step)
		
		puts "Found node '#{name_next_step}' in our travels, and have added it to the crew."
		
		parse(next_step)
		
		$cst.ascend()
		
	end
	
	
	###############################
	# Program ::== Block $
	#
	def program ()
		
		parse("Block", block())
		match_token("$", "T_EOFSIGN", $tokens[$index])
	

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
			raise FaultyTokenError.new(false, $tokens[$index])
		end
		
	end

	###############################
	# Print ::== print ( Expr )
	#
	def print_stmt ()
	
		match_token("print", "T_PRINT", $tokens[$index])
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
	# VarDec ::== type Id
	#
	def vardecl ()
		
		parse("type", type())
		parse("Id", id())
	
	end

	###############################
	# While ::== while BooleanExpr Block
	#
	def while_stmt ()
		
		match_token("while", "T_WHILE", $tokens[$index])
		parse("BooleanExpr", boolexpr())
		parse("Block", block())
		
	end

	###############################
	# If ::== if BooleanExpr Block
	#
	def if_stmt ()
		
		match_token("if", "T_IF", $tokens[$index])
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
		when "T_LPAREN"
			parse("BooleanExpr", boolexpr())
		when "T_ID"
		
		else
			raise FaultyTokenError.new(false, $tokens[$index])
		end
		
		
	end

	###############################
	# IntExpr 	::== digit intop Expr
	#			::== digit
	#
	def intexpr
	
	
	end

	###############################
	# StringExpr ::== " CharList "
	#
	def stringexpr
	
	
	end

	###############################
	# BooleanExpr 	::== ( Expr boolop Expr )
	#				::== boolval
	#
	def boolexpr
	
	
	end

	###############################
	# Id ::== char
	#
	def id
	
	
	end

	###############################
	# CharList	::== char CharList
	#			::== space CharList
	#			::== Ɛ
	#
	def charList
	
	
	end

	###############################
	# type	::== int | string | boolean
	#
	def type
	
	
	end

	###############################
	# char	::== [a-z]
	#
	def char
	
	
	end

	###############################
	# space	::== space
	#
	def space
	
	
	end

	###############################
	# digit	::== [0-9]
	#
	def digit
	
	
	end

	###############################
	# boolop ::== == | !=
	#
	def boolop
	
	
	end

	###############################
	# boolean ::== false | true
	#
	def boolean
	
	
	end

	###############################
	# intop ::== +
	#
	def intop
	
	
	end
	
end