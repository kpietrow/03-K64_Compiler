#!/usr/bin/env ruby

# Works with the symbol table


# first pass after Lexer
def f_pass (tokens)
	s_table = Hash.new
	
	for token in tokens
		if token.type == "T_ID"
			s_table[token.value] = [token.lineno, token.pos]
		end
	end
	
	return s_table
end