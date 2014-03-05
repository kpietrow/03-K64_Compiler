#!/usr/bin/env ruby
# Building the CST

# TODO: Should probably set it so that there's a function 
# which takes care of parsing output
 
#################################################################
# Helper functions, Error declarations, Class declarations,
# and all of that shiny stuff

# Set up a class for unexpected tokens
class FaultyTokenError < StandardError 
	def initialize(e_token, token)
		puts "ERROR: Expected a(n) #{e_token} token, received a(n) #{token.type} at Line #{token.lineno} Position #{token.pos}"
		exit
	end
end
	

# tentative class of a tree
class CST
	
	@@total_nodes = 0
	@branches = []
	@root = nil
	@cur = nil
	
	
	def initialize
		@branches = []
		@root = nil
		@cur = nil
	end
	
	# add a node
	def add_node(type, terminal, node)
		@@total_nodes += 1
		
		# if there are no nodes yet, start it off!
		if @root == nil
			branches.push([node])
			@root = node
			@cur = node
			return
		
		# otherwise, move about this intelligently
		else
			insert_node(@branches, terminal, node)
			return
		end
	end
	
	# helper method to add node
	def insert_node (nodes, terminal, n_node)
	
		# cycle through all the nodes
		nodes.cycle(1) { |node| 
			
			# check for parent's id
			# if successful...
			if node[0] == @cur
			
				# add child to parent's list of children
				node[0].children.push(n_node)
				
				# add parent to child's list of parents
				n_node.parent = node[0]
				
				# push child node into tree
				node.push([n_node])
				
				# if the new node is not terminal, update
				if !terminal
					@cur = node
				end
				
				return
				
			# else continue along current branch if there are more children
			else
				if !node.is_a? Array
					node_finder(node, parentid, n_node)
				end
			end 
		}
	end
	
end

# tentative class for nodes on the tree
class Node
	attr_reader :total_id, :id, :token
	attr_accessor :parent, :children
	
	@@total_id = 0
	@id = nil
	@name = nil
	@token = token
	@children = []
	@parent = nil
	
	def initialize (name, token, parent = nil, children = nil)
		@@total_id += 1
		@id = @@total_id
		@token = token
		@parent = parent
		@children = children_ids(children)
	end
	
	# if children given, return children ids
	def children_ids (children)
		if children == nil
			return []
		else
			ids = []
			children.cycle(1) {|child| ids.push(child.id) }
			return ids
		end
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
def t_next (index, tokens)
	return tokens[index + 1]
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

# watered down match_token. returns type of next token
def scout_token (index, tokens)
	return tokens[index + 1].type
end

#################################################################
# Main functions in the best gorram' parse tree in the Verse


# main function for this file
def parser (tokens)
	
	index = 0
	
	# create the new, concrete syntax tree
	# making it global to reduce headaches (hopefully XD )
	$cst = CST.new
	
	# have to ask alan about this
	if tokens.length <= 1
		puts "Insufficient code present! There is only #{tokens.length} token(s) here!"
		exit
	end	
	
	# $cst.addNode("Program")
	block(index, tokens)
	match_token("T_EOFSIGN", tokens[index])
end

##
# Block ::== { StatementList }
#
def block (index, tokens)
	
	# $cst.add_node("Block")
	
	if match_token("T_LBRACE", tokens[index])
		# $cst.add_node("LBrace")
	
		if != match_token("T_RBRACE", tokens[index + 1])
			index = index + 1
			statement_list(index, tokens)
		else
			# error
		end
	else
		# error
	end
	
	if match_token("T_RBRACE", tokens[index])
		# cst.add_node("RBrace")
	end
end



# old code for Block. saving it just in case
=begin
	if !match_token("T_LBRACE", tokens[index])
		raise FaultyTokenError.new("T_LBRACE", tokens[index])
	end
	
	# Confirm '{' token
	if match_token("T_LBRACE", tokens[index])
		index = index + 1
	
		# Confirm that there is a statement list, then go
		if t_next(index, tokens) =! "T_RBRACE"
		index = index + 1
		result = statement_list (index, tokens)
	
	
	
	
	# elsif return blank block
	
	end	
end
=end

##
# StatementList ::== Statement StatementList
#				::== Ɛ
#
def statement_list
	# $cst.add_node("T_STATEMENT
	
	
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