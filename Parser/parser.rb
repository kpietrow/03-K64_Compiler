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
	def add_node (node)
		@@total_nodes = @@total_nodes + 1
		
		# if there are no nodes yet, start it off!
		if @root == nil
			@root = node
			@cur = node
			return
		
		# otherwise, move about this intelligently
		else
			@cur.children.push(node)
			node.parent = @cur
			@cur = node
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
	
	def initialize (name, token = nil, parent = nil, children = [])
		@@total_id += 1
		@id = @@total_id
		@token = token
		@parent = parent
		@children = children
	end
	
	# if children given, return children ids
	def add_child (child)
		@children.push(child)
	end
	
	def add_parent (parent)
		@parent = parent
	end
	
	def get_child (id)
		for child in @children
			if child.id == id
				return child
			end
		end
	end
end
	
	
	

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
	
	# have to ask alan about this
	if $tokens.length <= 1
		puts "Insufficient code present! There is only #{$tokens.length} token(s) here!"
		exit
	end	
	
	# $cst.addNode("Program")
	block()
	match_token("T_EOFSIGN", $tokens[$index])
end

##
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



# old code for Block. saving it just in case
=begin
	if !match_token("T_LBRACE", $tokens[$index])
		raise FaultyTokenError.new("T_LBRACE", $tokens[$index])
	end
	
	# Confirm '{' token
	if match_token("T_LBRACE", $tokens[$index])
		$index = $index + 1
	
		# Confirm that there is a statement list, then go
		if t_next() =! "T_RBRACE"
		$index = $index + 1
		result = statement_list ()
	
	
	
	
	# elsif return blank block
	
	end	
end
=end

##
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

##
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

##
# Print ::== print ( Expr )
#
def print_stmt ()
	# $cst.add_node("PrintStmt")
	
	match_token("T_PRINT", $tokens[$index])
	
	# $cst.add_node("Print") (terminal)
	
	$index = $index + 1
		
end

##
# Assignment ::== Id = Expr
#
def assignment_stmt ()
	
	
end

##
# VarDec ::== type Id
#
def vardecl ()
	
	
end

##
# While ::== while Boolean Block
#
def while_stmt ()
	
	
end

##
# If ::== if Boolean Block
#
def if_stmt ()

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