#!/usr/bin/env ruby

# It's my estimation that  we're gonna be examining incoming input
# here, and translating it with our nice Lexer into some tokens


class Token
	# Establishin' a token class for easier categorization
	
	attr_accessor :type, :line, :position, :total_tokens
	
	def initialize(type, line, pos)
		@type = type
		@line = line
		@position = pos
		@@total_tokens = @@num_tokens + 1
	end
end

# error for unknown symbols
# exits program, prints line and line number
class UnknownSymbol < RuntimeError
	def initialize(lineno, pos, char)
		puts "Line: #{lineno}, Position: #{pos}, Character: #{char}: ERROR: This here character don't appear to be known to no-one around these parts."
		exit
	end
end



# Settin' up some basic regex searches now
$digit = /[0-9]/
$alpha_numeric = /[a-z0-9]/

# $alpha_numeric = /\w/ 
# an option in case underscores are valid in variable names

$character = /[a-z]/
$space = /\s/
$eof = /\$/
$token_list = ["T_ASSIGNMENT", "T_LBRACE", "T_RBRACE", "T_LPAREN", 
				"T_RPAREN", "T_QUOTE", "T_EQUALTO", "T_NOTEQUAL", "T_PLUS", 
					"T_EOFSIGN", "T_IF", "T_WHILE", "T_TRUE", "T_FALSE"]

# note, this here includes whitespace, so be careful about where it's used
$operator = /\W/

# examine for potential as an operator token
def op_tokenize (p_token, lineno, pos)
	case p_token
	when "="
		return true, Token.new("T_ASSIGNMENT", lineno, pos)
	when "{"
		return true, Token.new("T_LBRACE", lineno, pos)
	when "}"
		return true, Token.new("T_RBRACE", lineno, pos)
	when "("
		return true, Token.new("T_LPAREN", lineno, pos)
	when ")"
		return true, Token.new("T_RPAREN", lineno, pos)
	when "\""
		return true, Token.new("T_QUOTE", lineno, pos)
	when "=="
		return true, Token.new("T_EQUALTO", lineno, pos)
	when "!="
		return true, Token.new("T_NOTEQUAL", lineno, pos)
	when "+"
		return true, Token.new("T_PLUS", lineno, pos)
	when "$"
		return true, Token.new("T_EOFSIGN", lineno, pos)
	else
		raise UnknownSymbol(lineno, pos, p_token)
	end
end

# take in the potential token, type (char/op), lineno, and pos
def tokenize (p_token, type, lineno, pos)
	if type == "op"
		test, token = op_tokenize(p_token, lineno, pos)
	
	# will implement once op_tokenize is finalized
	# elsif type == "char"
		# test, token = char_tokenize
	
	end
end

def Lexer(input)
	# We're gonna run a nice Lexer now
	# Get ourselves some tokens
	
	# Startin' with the input code in a mighty nice array
	tokens = []
	
	# current line in program
	c_line = 0
	
	for line in input
		c_string = ""
		c_pos = nil
		
		for i in 0...line.length
			# test here for EOF
			if $eof.match(line[i])
				puts "EOF reached, partner"
				if c_string != ""
					test, token = tokenize(c_string, "char", c_line, c_pos)
					if test
						tokens.push(token)
					end
					c_string = ""
					c_pos = nil
				end
				break
				
			# Testin' for whitespace
			elsif $space.match(line[i])
				if c_string != ""
					test, token = tokenize(c_string, "char", c_line, c_pos)
					if test
						tokens.push(token)
					end
					c_string = ""
					c_pos = nil
				end
			
			# Testin' for operators
			# note: the whitespace issue was handled with the previous elsif
			elsif $operator.match(line[i])
				
				# tokenize c_string if applicable
				if c_string != ""
					test, token = tokenize(c_string, "char", c_line, c_pos)
					if test
						tokens.push(token)
					end	
					c_string = ""
					c_pos = nil
				end
				
				# either way, attempt to tokenize the operator
				test, token = tokenize(line[i], "op", c_line, c_pos)
				if test
					tokens.push(token)
				end	

			# Testin' for alpha numeric characters
			elsif $alpha_numeric.match(line[i])
				if c_string == "" and c_pos == nil
					c_pos = i
				end
				c_string = c_string + String(line[i])
			
			# else raise error for unknown symbol
			else
				raise UnknownSymbol(c_line, i, line[i])
			end
		end
		
		# increment the line number
		c_line = c_line + 1
	end
end


def test(input)
	for line in input
		case line[0]
		when "T"
			puts "it's a t!"
		else 
			puts "not a t"
		end
	end
end

