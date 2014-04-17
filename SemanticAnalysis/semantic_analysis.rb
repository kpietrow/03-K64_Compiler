#!/usr/bin/env ruby


###################################################
# This is the tokenizer of the 03-K64 Compiler.
# Crafted for Alan's 'Design Compilers' class,
# narrated by her captain, and lovingly coded in
# Ruby magic.
#
#
# Author: Kevin Pietrow
# Version: The shinier one
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

	puts "node_analyzer"
	
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
		
	else
		node.children.cycle(1) { |child| node_analyzer(child) }
	end
	
end


def match_block (node)
	
	puts "match_block"
	
	$ast.add_branch("block")
	$st.enter
	node.children.cycle(1) { |child| node_analyzer(child) }
	$st.exit
	$ast.ascend

end

def match_vardecl (node)

	puts "match_vardecl"

	$ast.add_branch("declare")
	$ast.add_leaf(node.children[0].children[0].token.value, node.children[0].children[0].token)
	$ast.add_leaf(node.children[1].children[0].children[0].token.value, node.children[1].children[0].children[0].token)	
	$ast.ascend
	
	#$st.add_symbol(node.children[0].children[0].token.value, node.children[1].children[0].children[0].token.value)
	
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

	puts "match_print"
	
	$ast.add_branch("print")
	match_expr(node.children[2])
	$ast.ascend

end

def match_while_statement (node)

	puts "match_while"
	
	$ast.add_branch("while")
	match_booleanexpr(node.children[1])
	match_block(node.children[2])
	$ast.ascend

end


def match_expr (node)

	puts "match_expr"
	
	if node.children[0].name == "IntExpr"
		match_intexpr(node.children[0])
				
	elsif node.children[0].name == "StringExpr"
		match_stringexpr(node.children[0])
	
	elsif node.children[0].name == "BooleanExpr"
		match_booleanexpr(node.children[0])
	
	elsif node.children[0].name == "Id"
		match_idexpr(node.children[0])
	
	else
		#raise error
	end
	
end


def match_intexpr (node)

	puts "match_intexpr"
	
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

	puts "match_stringexpr"

	$ast.add_leaf(node.children[1].children[0].token.value, node.children[1].children[0].token)
	
end


def match_booleanexpr (node)

	puts "match_booleanexpr"
	
	if node.children.length == 5
		$ast.add_branch(node.children[2].children[0].token.value)
		match_expr(node.children[1])
		match_expr(node.children[3])
	
	else
		$ast.add_leaf(node.children[0].children[0].token.value, node.children[0].children[0].token)
	end

end


def match_idexpr (node)

	if $st.scan_table(node.children[0].children[0].token.value)
		$add.add_leaf(node.children[0].children[0].token.value, node.children[0].children[0].token)
	else
		raise SymbolTableUndeclaredError.new(node.children[0].children[0].token.value)
	end

end