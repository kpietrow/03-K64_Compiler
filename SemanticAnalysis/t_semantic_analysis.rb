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


class UnknownTypeError < StandardError
	def initialize (node)
		puts "ERROR: Unknown type received. Location is approximately at Line: #{node.lineno} and Position #{node.pos}"
		exit
	end
end

class TypeMismatchError < StandardError
	def initialize (exp, received, token)
		puts "ERROR: Exprected a type '#{exp}', but received a type '#{received} on Line #{token.lineno}"
		exit
	end
end
		
class MysteriousError < StandardError
	def initialize
		puts "ERROR: The worst has come to pass. Only the gods can help us now."
		exit
	end
end



def semantic_analysis

	$ast = AbstractSyntaxTree.new
	$st = SymbolTable.new
	$index = 0

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
		
	else
		node.children.cycle(1) { |child| node_analyzer(child) }
	end
	
end


def match_block (node)
	
	puts String($index += 1) + " " + $st.c_scope + "Entering a new block, creating scope"
	
	$ast.add_branch("block")
	$st.enter
	node.children.cycle(1) { |child| node_analyzer(child) }
	$st.exit
	$ast.ascend
	
	puts String($index += 1) + " " + $st.c_scope + "Leaving block, exiting scope"


end

def match_vardecl (node)

	$ast.add_branch("declare")
	$ast.add_leaf(node.children[0].children[0].token.value, node.children[0].children[0].token)
	$ast.add_leaf(node.children[1].children[0].children[0].token.value, node.children[1].children[0].children[0].token)	
	$ast.ascend
	
	$st.add_symbol(node.children[0].children[0].token.value, node.children[1].children[0].children[0].token.value, node.children[1].children[0].children[0], node.children[1].children[0].children[0].token)
	
	puts String($index += 1) + " " + $st.c_scope + "Declaration: Adding symbol: '" + node.children[1].children[0].children[0].token.value + "' of type: " + node.children[0].children[0].token.value
	
end

def match_assignment_statement (node)

	$ast.add_branch("assign")
	
	$ast.add_leaf(node.children[0].children[0].children[0].token.value, node.children[0].children[0].children[0].token)
	match_expr(node.children[2])
	
	type = determine_type($ast.current)
	$st.update_symbol(type, node.children[0].children[0].children[0].token.value, $ast.current, node.children[0].children[0].children[0].token, node.children[2])
	
	$ast.ascend
	
	puts String($index += 1) + " " + $st.c_scope + "Assignment: " + type + " to " + type

end

def match_if_statement (node)

	puts String($index += 1) + " " + $st.c_scope + "If Statement encountered"

	$ast.add_branch("if")
	
	match_booleanexpr(node)
	match_block(node)
	
	$ast.ascend

end

def match_print_statement (node)

	puts String($index += 1) + " " + $st.c_scope + "Print Statement encountered"
	
	$ast.add_branch("print")
	match_expr(node.children[2])
	$ast.ascend

end

def match_while_statement (node)

	puts String($index += 1) + " " + $st.c_scope + "While Statement encountered"
	
	$ast.add_branch("while")
	match_booleanexpr(node.children[1])
	match_block(node.children[2])
	$ast.ascend

end


def match_expr (node)
	
	if node.children[0].name == "IntExpr"
		match_intexpr(node.children[0])
				
	elsif node.children[0].name == "StringExpr"
		match_stringexpr(node.children[0])
	
	elsif node.children[0].name == "BooleanExpr"
		match_booleanexpr(node.children[0])
	
	elsif node.children[0].name == "Id"
		match_idexpr(node.children[0])
	
	else
		raise UnknownNodeError.new(node.children[0])
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
		$ast.add_branch(node.children[2].children[0].token.value)
		match_expr(node.children[1])
		match_expr(node.children[3])
		$ast.ascend
	
	else
		
		$ast.add_leaf(node.children[0].children[0].token.value, node.children[0].children[0].token)
	end

end


def match_idexpr (node)

	puts String($index) + " " + $st.c_scope + "Checking existence of " + node.children[0].children[0].token.value 

	if $st.scan_table_used(node.children[0].children[0].token.value)
		$ast.add_leaf(node.children[0].children[0].token.value, node.children[0].children[0].token)
		
	else
		raise SymbolTableUndeclaredError.new(node.children[0].children[0].token.value)
	end

end


def determine_type (node)
	
	tester = ""
	
	if node.children[1].type == "leaf"
		tester = node.children[1].name
		
	else
			
		def small_loop (node, tester)
			
			tester = tester + " " + node.name
			for child in node.children
				tester = small_loop(child, tester)
			end
			
			return tester
		end
		
		tester = small_loop(node.children[1], tester)
	end

	tester = tester.scan(/\w+/)
	
	for sequence in tester
		if /\b==\b/.match(sequence) or /\btrue\b/.match(sequence) or /\bfalse\b/.match(sequence) and sequence.length > 2
			return "boolean"
			
		elsif /\b[a-z]\b/.match(sequence)
			if $st.scan_table_used(sequence)
				type = $st.retrieve_type(sequence)
				return type
					
			else
				return "string"
			end
		elsif /[a-z]/.match(sequence)
			return "string"
		elsif /[0-9]/.match(sequence) or (/[+]/.match(sequence) and sequence.length > 1)
			return "int"
		else
			raise UnknownTypeError.new(node.parent.children[0])
		end
	end
end
	
	
	
	