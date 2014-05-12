#!/usr/bin/env ruby

##################################
# Starter function for code gen
#

class UnfinishedError < StandardError
	def initialize (function)
		puts "ERROR: '#{function}' isn't supported yet"
		exit
	end
end



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
		return generate_equals(node)
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


def generate_block (node)
	for child in node.children
		generate(child)
	end
end


######################
# Add symbol to static table
#
def generate_declaration (node)

	entry = $static_table.add(node.children[1].symbol)
	lda("00")
	sta(entry.address)

end


######################
# Assign new value to symbol
#
def generate_assignment (node)

	# right side
	generate(node.children[1])

	sta($static_table.get(node.children[0].symbol).address)

end


######################
# Generates a string
#
def generate_string (node)
	# add string to heap
	address = $code.add_string(node.name)
	# load string's address
	lda(hex_converter(address, 2))
end


######################
# Generate a print statement
#
def generate_print (node)
	child = node.children[0]

	# string symbol
	if child.token.type == "T_STRING" and child.symbol != nil
		ldx("02")
		ldy($static_table.get(child).address)
		sys
	# normal string
	elsif child.token.type == "T_STRING" and child.symbol != nil
		address = $code.add_string(child.name)
		lda(hex_converter(address, 2))
		sta
		ldx("02")
		ldy
		sys
	else
		generate(child)
		ldx("01")
		sta
		ldy
		sys
		
	end

end


def generate_add (node)

	generate(node.children[1])
	adc(node.children[0].name)
	
end


def generate_equals (node)
	raise UnfinishedError.new("==")
end


def generate_notequal (node)
	raise UnfinishedError.new("!=")
end


A9 FA 8D 0B 00 AC 0B 00 A2 02 FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 6F 6F 70 00 00 

A9 00 8D 11 00 A9 FB 8D 11 00 A2 02 AC 11 00 FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 6F 6F 70 00

A9 FB 8D 0C 00 A2 02 AC 0C 00 FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 6F 6F 70 00

def generate_id (node)

	lda($static_table.get(node.symbol).address)

end


def generate_digit (node)

	digit = prepad(Integer(node.name).to_s(16), 2, "0")
	lda(digit)

end


def generate_boolean (node)

	if (node.name == "true")
		lda("01")
		sta
		ldx("01")
		cpx
	else
		lda("00")
		sta
		ldx("01")
		cpx
	end

end











######################
# 6502 instructions
# Default address set to 'FF00'
#
default_address = "FF00"


######################
# Add with carry
# 
def adc (input = default_address)

	if input.length > 2
		$code.add("6D" + input)
	else
		sta
		lda
		adc
	end

end


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












