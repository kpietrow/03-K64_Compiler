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

def generate_declaration(node)



end