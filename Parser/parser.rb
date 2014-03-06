#!/usr/bin/env ruby
# Building the CST

# TODO: Should probably set it so that there's a function 
# which takes care of parsing output
 
#################################################################
# Helper functions, Error declarations, Class declarations,
# and all of that shiny stuff

# Set up a class for unexpected $tokens
class FaultyTokenError < StandardError 
	def initialize(e_token, token)
		puts "ERROR: Expected a(n) #{e_token} token, received a(n) #{token.type} at Line #{token.lineno} Position #{token.pos}"
		exit
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
	def add_node (node, token = nil)
		@@total_nodes = @@total_nodes + 1
		
		# if there are no nodes yet, start it off!
		if @root == nil
			@root = Node.new(node, token)
			@cur = @root
		
		# otherwise, move about this intelligently
		else
			new_node = @current.add_child(node, token)
			@current = 
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
	
	def initialize (name, token = nil)
		@@total_id = @@total_id + 1
		@id = @@total_id
		@name = name
		@token = token
		@parent = parent
		@children = children
	end
	
	# add child, set child's parent
	def add_child (child, token = nil)
		@children.push(child)
		@children[child].add_parent(self)
		return 
	end
	
	# add parent
	def add_parent (parent)
		@parent = parent
	end
	
end



#################################################################
# Main functions in the best gorram' parse tree in the Verse


# main function for this file
def parser (tokens)

	# create the new, concrete syntax tree
	# making it global to reduce headaches (hopefully XD )
	$cst = CST.new
	
	# define some other useful, global vars
	$tokens = tokens
	$index = 0
	$symbol_tbl = SymbolTbl.new()
	
	# have to ask alan about this
	if $tokens.length <= 1
		puts "Insufficient code present! There is only #{$tokens.length} token here!"
		exit
	end	
	
	# $cst.addNode("Program")
	block()
	match_token("T_EOFSIGN", $tokens[$index])
	
	###############################
	# The all-important parser
	# This will control the ascent and descent of the 
	# nodes in the CST, and will help to structure the program
	#
	def parse (next_step)
		
		
	end
	
	
	

	###############################
	# Block ::== { StatementList }
	#
	def block ()
	
		# $cst.add_node("Block")
	
		if match_token("T_LBRACE", $tokens[$index])
			# $cst.add_node("LBrace")
	
			$index = $index + 1
			statement_list()
		
		else
			# error
		end
	
		if match_token("T_RBRACE", $tokens[$index])
			# cst.add_node("RBrace")
		else
			# error
		end
	end



	###############################
	# StatementList ::== Statement StatementList
	#				::== Ɛ
	#
	def statement_list ()
		# $cst.add_node("StatmentList")
	
		if $tokens[$index].type != "T_RBRACE"
			statement()
			statement_list()
		else
			return
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
		# $cst.add_node("Statement")
	
		case $tokens[$index].type
		when "T_PRINT"
			print_stmt()
		when "T_ID"
			assignment_stmt()
		when "T_TYPE"
			vardecl()
		when "T_WHILE"
			while_stmt()
		when "T_IF"
			if_stmt()
		when "T_LBRACE"
			block()
		else
			#error
		end
		
	end

	###############################
	# Print ::== print ( Expr )
	#
	def print_stmt ()
		# $cst.add_node("PrintStmt")
	
		match_token("T_PRINT", $tokens[$index])
	
		# $cst.add_node("Print") (terminal)
	
		$index = $index + 1
		
	end

	###############################
	# Assignment ::== Id = Expr
	#
	def assignment_stmt ()
	
	
	end

	###############################
	# VarDec ::== type Id
	#
	def vardecl ()
	
	
	end

	###############################
	# While ::== while Boolean Block
	#
	def while_stmt ()
	
	
	end

	###############################
	# If ::== if Boolean Block
	#
	def if_stmt ()

	end

	###############################
	# Expr	::== IntExpr
	# 		::== StringExpr
	#		::== BooleanExpr
	#		::== Id
	#
	def expr
	
	
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
	# BooleanExpr 	::== ( expr boolop Expr )
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
	
	
	
	##########################################
	# Helper functions
	
	# retrieves the next token
	def t_next ()
		return $tokens[$index + 1]
	end


	# testing for a token match. value, expected, received
	def match_token (exp, token)
		puts "Token received: #{token.value}"
		puts "\nExpecting token of type: #{exp}"
	
		if exp == rec
			puts "\n\nShiny! Got #{token.type}!"
			return true
		else
			return false
		end
	end
end