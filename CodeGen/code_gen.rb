#!/usr/bin/env ruby

##################################
# Starter function for code gen
#

def code_gen

	$code = Code.new
	$symbol_tableatic_table = StaticTable.new
	$jump_table = JumpTable.new
	
	generate($ast.root)
	
	
	
end


##################################
# Handles most of the routing for
# all of the recursive glory
#

def generate (node)

	if node.symbol != nil
		return generate_id(node)
	end
	
	case node.name
	when "block"
		return generate_block(node)
	when "while"
		return generate_while(node)
	when "if"
		return generate_if(node)
	when "declaration"
		return generate_declaration(node)
	when "assign"
		return generate_declaration(node)
	when "print"
		return generate_print(node)
	when "+"
		return generate_add(node)
	when "=="
		return generate_equal(node)
	when "!="
		return generate_notequal(node)
	end
	
	case node.token.type
	when "T_BOOLEAN"
		return generate_boolean(node)
	when "T_DIGIT"
		return generate_digit(node)
	when "T_STRING"
		return generate_string(node)
	end
	
	puts "WHOAAAAA"

end


def generate_block(node)
	for child in node.children
		generate(child)
	end
end


######################
# Add symbol to static table
#
def generate_declaration(node)

	

end

######################
# 6502 instructions
# Default address set to 'FF00'
#
default_address = "FF00"


######################
# Load Accumulator
# If input length is 2, it's a constant
# Else, id
# 
def lda (input = default_address)

	if input.length length > 2
		$code.add("AD" + input)
	else
		$code.add("A9" + input)
	end

end


######################
# Store accumulator
#
def sta (input = default_address)
	$code.add("8D" + input)
end


######################
# Load X register
#
def ldx (input = default_address)
	
	if input.length > 2
		$code.add("AE" + input)
	else
		$code.add("A2" + input)
	end

end


######################
# Load Y register
#
def ldy (input = default_address)
	
	if input.length > 2
		$code.add("AC" + input)
	else
		$code.add("A0" + input)
	end

end


######################
# Break/System Call
#
def brk
	$code.add("00")
end


######################
# Compare
#
def cpx (input = default_address)
	$code.add("EC" + input)
end


######################
# Branch not equal
#
def bne (input = default_address)
	$code.add("D0" + input)
end


######################
# System call
#
def sys
	$code.add("FF")
end












