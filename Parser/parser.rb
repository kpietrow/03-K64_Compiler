#!/usr/bin/env ruby
# Building the CST

# TODO: Should probably set it so that there's a function 
# which takes care of parsing output
 

# Set up a class for unexpected tokens
class FaultyTokenError < StandardError 
	def initialize(e_token, token)
		puts "ERROR: Expected a(n) #{e_token} token, received a(n) #{token.type} at Line #{token.lineno} Position #{token.pos}"
		exit
	end
end
	

# tentative class of a tree
class Tree
	
	@@total_nodes = 0
	@branches = []
	
	
	def initialize
	end
	
	# add a node
	def add_node(token, parent = nil)
		
		# if no parent, new branch!
		if parent == nil
			branches.push([token])
			return
			
		else
			node_adder(@branches, parent.id, token)
			return
		end
	end
	
	# helper method to add node
	def node_adder (nodes, parentid, token)
	
		# cycle through all the nodes
		nodes.cycle(1) { |node| 
			
			# check for parent's id
			if node[0] == parentid
				node.push([token])
				
			# else continue along branch, unless current branch has no children
			else
				if !node.is_a? Integer
					node_finder(node, parentid, token)
				end
			end 
		}
	end
	
end

# tentative class for nodes on the tree
class Node (token, parentid = nil, children = [])
	@@total_id = 0
	@id = 0
	@token = nil
	@parentid = nil
	@children = nil
	
	def initialize (token, parent, children)
		@@total_id += 1
		@id = @@total_id
		@token = token
		@parent = parent
		@children = children
	end
	
	def get_child (id)
		for child in @children
			if child.id == id
				return child
			end
		end
	end
	
	def id
		@id
	end
	
	def parentid
		@parentid
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


def parser (tokens)
	
	index = 0
	
	# have to ask alan about this
	if tokens.length <= 1
		puts "Insufficient code present"
		exit
	end	
	
	cst = block(index, tokens)
	
end

##
# Block ::== { StatementList }
#
def block (index, tokens)

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