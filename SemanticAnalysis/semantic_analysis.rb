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



def semantic_analysis (cst)


	$ast = AbstractSyntaxTree.new
	symbol_table = SymbolTable.new

	puts cst.root
	node_analyzer(cst.root)
	#analyze_element(cst.roo
	
	
end
	
	
def node_analyzer (node)
	
	if node.name == "Block"
		ast.add_branch("Block")
		#symbol_table.enter
		node.children.cycle(1) { |child| node_analyzer(child) }
		ast.ascend
		#symbol_table.leave
		
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

def match_unknown_expr (node)

	

end



def match_vardecl (node)

	$ast.add_branch("VarDecl")

	match_leaf("T_TYPE", node.children[0].children[0])
	
	match_leaf("T_ID", node.children[1].children[0].children[0])
	
	$ast.ascend

end

def match_assignment_statement (node)

	$ast.add_branch("Assignment")
	
	match_leaf("T_ID", node.children[0].children[0].children[0])
	
	match_leaf("T_ASSIGNMENT", node.children[1])
	
	match__unknown_expr(node.children[2].children[0])
	
	$ast.ascend

end

def match_if_statement (node)

	

end

def match_print_statement (node)

	

end

def match_while_statement (node)

	

end