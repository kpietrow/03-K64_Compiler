#!/usr/bin/env ruby


###################################################
# This is the tokenizer of the 03-K64 Compiler.
# Crafted for Alan's 'Design Compilers' class,
# lovingly coded in Ruby magic and narrated by
# her captain.
#
#
# Author: Kevin Pietrow
# Version: The shiny one
# 
# Note: Instructions for running the best compiler
# 		in the Verse can be found in the README
#



def semantic_analysis

	$ast = AbstractSyntaxTree.new
	$st = SymbolTable.new

	node_analyzer($cst.root)
	
end
	
	
def node_analyzer (node)
	
	if node.name == "Block"
		match_block(node)
		
	elsif node.name == "VarDecl"
		match_vardecl(node)
		
	elsif node.name == "AssignmentStatement"
		match_assignment_statement(node)
		
	elsif node.name == "PrintStatement"
		match_print_statement(node)
		
	elsif node.name == "WhileStatement"
		match_while_statement(node)
		
	elsif node.name == "IfStatement"
		match_if_statement(node)
		
	elsif node.type == "leaf"
		evaluate_leaf(node)
	end
	
end


def match_block (node)
	
	puts "match_block"
	
	$ast.add_branch("stmt block")
	$st.enter
	node.children.cycle(1) { |child| node_analyzer(child) }
	$st.exit
	$ast.ascend

end

def match_vardecl (node)

	puts "match_vardecl"

	$ast.add_branch("declare")
	match_leaf("T_TYPE", node.children[0].children[0])
	match_leaf("T_ID", node.children[1].children[0].children[0])	
	$ast.ascend

end

def match_assignment_statement (node)

	puts "match_assignment"

	$ast.add_branch("assignment")
	
	$ast.add_leaf(node.children[0].children[0].children[0].token.value, node.children[0].children[0].children[0].token)
	
	match_expr(node.children[2])
	
	$ast.ascend

end

def match_if_statement (node)

	puts "match_if"

	$ast.add_branch("if")
	
	match_comparison(node)
	match_block(node)
	
	$ast.ascend

end

def match_print_statement (node)

	

end

def match_while_statement (node)

	

end

def match_comparison (node)

	$ast.add_branch("comp")
	
	
	$ast.ascend
end


def match_expr (node)
	
	if node.children[0].type == "IntExpr"
		match_intexpr(node.children[0])
				
	elsif node.children[0].type == "StringExpr"
		match_stringexpr(node.children[0])
	
	elsif node.children[0].type == "BooleanExpr"
		match_booleanexpr(node.children[0])
	
	elsif node.children[0].type == "Id"
		match_id(node.children[0])
	
	else
		#raise error
	end
	
end


def match_intexpr (node)
	
	if node.children.length == 3
		$ast.add_branch("+")
		$ast.add_leaf(node.children[0].children[0].token.value, node.children[0].children[0].token)
		match_expr(node.children[2])
		$ast.ascend

	else 
		$ast.add_leaf(node.children[0].children[0].token.value, node.children[0].children[0].token)
	end
	
end


def match_stringexpr (node)

	$ast.add_leaf(node.children[1].children[0].token.value, node.children[1].children[0].token)
	
end


def match_booleanexpr (node)

	if node.children.length == 5
		match_expr(node.children[1])
		add_leaf(node.children[2].children[0].token.value, node.children[2].children[0].token)
		match_expr(node.children[3])
	
	else
		$ast.add_leaf(node.children[0].children[0].token.value, node.children[0].children[0].token)
	end

end