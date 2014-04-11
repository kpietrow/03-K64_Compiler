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


	ast = AbstractSyntaxTree.new
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
		
	elsif node.name == "VarDecl"
		match_vardecl(node)
		
	elsif node.name == "AssignmentStatement"
		
	elsif node.name == "PrintStatement"
		
	elsif node.name == "WhileStatement"
		
	elsif node.name == "IfStatement"
		
	elsif node.type == "leaf"
		evaluate_leaf(node)
	
	else
		node.children.cycle(1) { |child| node_analyzer(child) }
	end	
	
end


def match_vardecl

	

end