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
	$st = SymbolTable.new

	puts cst.root
	node_analyzer(cst.root)
	#analyze_element(cst.roo
	
	
end
	
	
def node_analyzer (node)
	
	if node.name == "Block"
		$ast.add_branch("stmt block")
		$st.enter
		node.children.cycle(1) { |child| node_analyzer(child) }
		$ast.ascend
		$st.exit
		
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

def match_expr (node)
	
	if node.type == "IntExpr"
	
	elsif node.type == "StringExpr"
		
	
	elsif node.type == "BooleanExpr"
	
	elsif node.type == "Id"
	
	else
		#raise error
	end
	

end



def match_vardecl (node)

	$ast.add_branch("declare")
	match_leaf("T_TYPE", node.children[0].children[0])
	match_leaf("T_ID", node.children[1].children[0].children[0])	
	$ast.ascend

end

def match_assignment_statement (node)

	$ast.add_branch("assignment")
	
	match_leaf("T_ID", node.children[0].children[0].children[0])
	
	match_expr(node.children[2].children[0])
	
	$ast.ascend

end

def match_if_statement (node)

	$ast.add_branch("if")
	
	$ast.add_branch("Comp")
	
	$ast.ascend

end

def match_print_statement (node)

	

end

def match_while_statement (node)

	

end