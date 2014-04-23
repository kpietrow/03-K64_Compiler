#!/usr/bin/env ruby


###################################################
# This is the tokenizer of the 03-K64 Compiler.
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


def convert_cst

	$ast = AbstractSyntaxTree.new
	$ast.root = traverse($cst.root)

end
	

def traverse (node)

	case node.name
	# Program
	when "Block"
		traverse_block(node)
	when "StatementList"
		return traverse_statementlist(node)
	when "Statement"
		return traverse_statement(node)
	# Expr
	when "IntExpr"
		return traverse_intexpr(node)
	when "StringExpr"
		return traverse_stringexpr(node)
	when "BooleanExpr"
		return traverse_booleanexpr(node)
	else
		return traverse_children(node)
	end

end


def traverse_children (node) 

	if node.children.length > 0
		for child in node.children
			return traverse(child)
		end
	else
		return build_leaf(node)
	end

end


def traverse_block (node)

	return build_branch("block", node, [traverse(node.children[1])])

end


def traverse_statementlist (node)

	child = node.children[0]
	children = []
	
	while child.name != "Epsilon"
		children.push(traverse(node.children[0]))
		
		node = node.children[1]
		child = node.children[0]
		
	end
	
	return children

end


def traverse_statement (node)
	child = node.children[0]
	
	if child.type == "branch"
		
		if child.name == "PrintStatement"
			return build_branch("print", node, [traverse(node.children[2])])
		elsif child.name == "VarDecl"
			return build_branch("declaration", node, [traverse(node.children[0]), traverse(node.children[1]))
		elsif child.name == "WhileStatement"
			return build_branch("while", node, [traverse(node.children[1]), build_branch("block", node, traverse(node.children[2]))])
		elsif child.name == "IfStatement"
			return build_branch("if", node, [traverse(node.children[1]), build_branch("block", node, traverse(node.children[2]))])
		elsif child.name == "Block"
			return build_branch("block", node, traverse(node.children[1]))
		elsif child.name == "AssignmentStatement"
			return build_branch("assignment", node, [traverse(node.children[0]), traverse(node.children[2])])
		end
end


def traverse_intexpr (node)

	if node.children.length == 1
		# not sure if build_leaf(traverse....) or not
		return traverse(node.children[0])
	else
		return build_branch("+", node [traverse(node.children[0]), traverse(node.children[2])])
	end

end


def traverse_stringexpr (node)

	return traverse(node.children[1])

end


def traverse_booleanexpr (node)

	child = node.children[0]
	
	if child.name == "("
		op_name = node.children[2].name
		return build_branch(op_name, node, [traverse(node.children[1]), traverse(node.children[3])])
	elsif
		return traverse(node.children[0]))
	end

end


def build_leaf (node)

	return ASTNode.new("leaf", node)

end


def build_branch (node, children = nil)

	new_node = ASTNode.new("branch", node)
	
	if children != nil
		for child in children
			child.parent = node
		end
		new_node.children = children
	else
		# error
	end
	
	return new_node
	
end
