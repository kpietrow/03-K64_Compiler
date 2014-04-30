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


class TypeMismatchError < StandardError
	def initialize (type1, type2, line)
		puts "ERROR: Recieved a type mismatch of type '#{type1}' and type '#{type2}' at line #{line + 1}"
		exit
	end
end

class UnexpectedTypeError < StandardError
	def initialize (type1, type2, line)
		puts "ERROR: Expected type '#{type2}', but received '#{type1}' at line #{line + 1}"
		exit
	end
end



def semantic_analysis

	$st = SymbolTable.new
	
	analyze($ast.root)
	
end


def analyze (node)

	if node.type == "branch"
		case node.name
		when "block"
			return analyze_block(node)
		when "print"
			return analyze(node.children[0])
		when "assign"
			return analyze_assign(node)
		when "declaration"
			return analyze_declaration(node)
		when "while"
			return analyze_while(node)
		when "if"
			return analyze_if(node)
		when "+"
			return analyze_op(node)
		when "=="
			return analyze_boolop(node)
		when "!="
			return analyze_boolop(node)
		end
		
	else
		case node.token.type
		when "T_STRING"
			return "string"
		when "T_DIGIT"
			return "int"
		when "T_BOOLEAN"
			return "boolean"
		when "T_ID"
			return analyze_id(node)
		end
		
	end
	
end


def analyze_block (node)

	puts "Analyzing block"

	$st.create_scope
	
	for child in node.children
		analyze(child)
	end
	
	$st.ascend

end


def analyze_assign (node)

	puts "Analyzing assign"
	
	line = node.children[0].token.lineno
	left_type = analyze(node.children[0])
	right_type = analyze(node.children[1])
	
	if left_type != right_type
		TypeMismatchError.new(left_type, right_type, line)
	end
	
	# set symbol as initialized
	symbol = $st.get_symbol(node.children[0].name, node.children[0].token.lineno)
	symbol.is_initialized = true
	
	return left_type
end


def analyze_declaration (node)

	puts "Analyzing declaration"

	id = node.children[1].name
	type = node.children[0].name
	
	$st.add_symbol(id, type, node.children[1].token.lineno)
	symbol = $st.get_symbol(id, node.children[1].token.lineno)
	symbol.is_initialized = true

end

def analyze_while (node)

	puts "Analyzing while"
	
	# ==
	analyze(node.children[0])
	# block
	analyze(node.children[1])

end


def analyze_if (node)
	
	puts "Analyzing if"
	
	# ==
	analyze(node.children[0])
	# block
	analyze(node.children[1])
	
end


def analyze_op (node)

	puts "Analyzing +"

	line = node.children[0].token.lineno
	type_left = analyze(node.children[0])
	
	if type_left != "int"
		raise UnexpectedTypeError.new(type_left, "int", line)
	end
	
	type_right = analyze(node.children[1])
	
	if type_right != "int"
		raise UnexpectedTypeError.new(type_right, "int", line)
	end

	return type_right

end


def analyze_boolop (node)
	
	line = node.children[0].token.lineno
	type_left = analyze(node.children[0])
	type_right = analyze(node.children[1])
	
	# Only thing we have to test for is right/left side equality
	# Our grammar can compare ints, strings, and bools
	if type_left != type_right
		raise TypeMismatchError.new(type_left, type_right, line)
	end
	
	return "boolean"

end


def analyze_id (node)

	symbol = $st.get_symbol(node.name, node.token.lineno)
	
	symbol.is_used = true
	
	return symbol.type

end