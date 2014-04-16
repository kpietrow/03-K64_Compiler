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

	$ast.add_branch("stmt block")
	$st.enter
	node.children.cycle(1) { |child| node_analyzer(child) }
	$st.exit
	$ast.ascend

end

def match_vardecl (node)

	$ast.add_branch("declare")
	match_leaf("T_TYPE", node.children[0].children[0])
	match_leaf("T_ID", node.children[1].children[0].children[0])	
	$ast.ascend

end

def match_assignment_statement (node)

	$ast.add_branch("assignment")
	
	$ast.add_leaf(node.children[0].children[0].children[0].token.value, node.children[0].children[0].children[0].token)
	
	match_expr(node)
	
	$ast.ascend

end

def match_if_statement (node)

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
	
	if node.children[2].children[0].type == "IntExpr"
		$st.update_symbol("int", node.children[0].children[0].children[0].token)
		match_intexpr(node.children[2].children[0])
				
	elsif node.children[0].type == "StringExpr"
		$st.update_symbol("string", node.children[0].children[0].children[0].token)
		match_stringexpr(node.children[2].children[0])
	
	elsif node.children[0].type == "BooleanExpr"
		$st.update_symbol("boolean", node.children[0].children[0].children[0].token)
		match_booleanexpr(node.children[2].children[0])
	
	elsif node.children[0].type == "Id"
		match_id(node.children[0])
	
	else
		#raise error
	end
	
end

def match_intexpr (node)
	
	
	def small_loop (node)
	
		if node.children.length > 1
			$ast.add_branch("+")
			$ast.add_leaf(node.children[0].children[0].token.value, node.children[0].children[0].token)
			small_loop(node.children[2])
			$ast.ascend
	
		else 
			$ast.add_leaf(node.children[0].children[0].token.value, node.children[0].children[0].token)
		end
	
	end
	
	small_loop(node, total)

end

def match_stringexpr (node)

	
	
end