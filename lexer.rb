#!/usr/bin/env ruby

# It's my estimation that  we're gonna be examining incoming input
# here, and translating it with our nice Lexer into some tokens

# TODO: add comment functionality
# TODO: check for EOF, and deal with it once reached
# -------- This includes early $s, and lack of $

class Token
	# Establishin' a token class for easier categorization
	
	attr_accessor :value, :type, :line, :position, :total_tokens
	
	def initialize(type, value, line, pos)
		@type = type
		@value = value
		@line = line
		@position = pos
		@@total_tokens = @@num_tokens + 1
	end
end

##
# error for unknown symbols
# exits program, prints line and line number
class UnknownSymbol < RuntimeError
	def initialize(char, lineno, pos)
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
					"T_EOFSIGN", "T_IF", "T_WHILE", "T_BOOLEAN", 
						"T_ID", "T_DIGIT", "T_PRINT", "T_TYPE"]

# note, this here includes whitespace, so be careful about where it's used
$operator = /\W/

# examine for potential as an operator token
def op_tokenize (p_token, lineno, pos)
	case p_token
	when "="
		return Token.new("T_ASSIGNMENT", p_token, lineno, pos)
	when "{"
		return Token.new("T_LBRACE", p_token, lineno, pos)
	when "}"
		return Token.new("T_RBRACE", p_token, lineno, pos)
	when "("
		return Token.new("T_LPAREN", p_token, lineno, pos)
	when ")"
		return Token.new("T_RPAREN", p_token, lineno, pos)
	when "\""
		return Token.new("T_QUOTE", p_token, lineno, pos)
	when "=="
		return Token.new("T_EQUALTO", p_token, lineno, pos)
	when "!="
		return Token.new("T_NOTEQUAL", p_token, lineno, pos)
	when "+"
		return Token.new("T_PLUS", p_token, lineno, pos)
	when "$"
		return Token.new("T_EOFSIGN", p_token, lineno, pos)
	else
		raise UnknownSymbol(p_token, lineno, pos)
	end
end

# dealing with alphanumeric character strings
def alphanum_tokenize(p_token, lineno, pos)

	# T_ID potential
	if (p_token =~ $character) and (p_token =~ $digit)
		
		# Can't start with a digit
		if p_token[0] =~ $digit
			raise UnknownSymbol(p_token, lineno, pos)
		else
			return Token.new("T_ID", p_token, lineno, pos)
		end
		
	# T_DIGIT. Tokenize its value as an int and not a string
	elsif p_token =~ $digit
		return Token.new("T_DIGIT", Integer(p_token), lineno, pos
	
	# could be a keyword, type, or id here
	elsif p_token =~ /[a-z]+/
		case p_token
		when /\b(while)\b/
			return Token.new("T_WHILE", p_token, lineno, pos)
		when /\b(if)\b/
			return Token.new("T_IF", p_token, lineno, pos)
		when /\b(false)\b/
			return Token.new("T_BOOLEAN", p_token, lineno, pos)
		when /\b(true)\b/
			return Token.new("T_BOOLEAN", p_token, lineno, pos)
		when /\b(print)\b/
			return Token.new("T_PRINT", p_token, lineno, pos)
		when /\b(int)\b/
			return Token.new("T_TYPE", p_token, lineno, pos)
		when /\b(string)\b/
			return Token.new("T_TYPE", p_token, lineno, pos)
		when /\b(boolean)\b/
			return Token.new("T_TYPE", p_token, lineno, pos)
		when /[a-z]+/
			return Token.new("T_ID", p_token, lineno, pos)
		else
			raise UnknownSymbol(p_token, lineno, pos)
		end
	else
		raise UnknownSymbol(p_token, lineno, pos)
	end
end

# take in the potential token, type (char/op), lineno, and pos
def tokenize (p_token, type, lineno, pos)
	if type == "op"
		token = op_tokenize(p_token, lineno, pos)
	
	elsif type == "alphanum"
		token = alphanum_tokenize(p_token, lineno, pos)
	
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
					tokens.push(tokenize(c_string, "alphanum", c_line, c_pos))
					
					c_string = ""
					c_pos = nil
				end
				break
				
			# Testin' for whitespace
			elsif $space.match(line[i])
				if c_string != ""
					tokens.push(tokenize(c_string, "alphanum", c_line, c_pos))
					
					c_string = ""
					c_pos = nil
				end
			
			# Testin' for operators
			# note: the whitespace issue was handled with the previous elsif
			elsif $operator.match(line[i])
				
				# tokenize c_string if applicable
				if c_string != ""
					tokens.push(tokenize(c_string, "alphanum", c_line, c_pos))
					
					c_string = ""
					c_pos = nil
				end
				
				# either way, attempt to tokenize the operator
				tokens.push(tokenize(line[i], "op", c_line, c_pos))

			# Testin' for alpha numeric characters
			elsif $alpha_numeric.match(line[i])
				# set position of current string
				if c_string == "" and c_pos == nil
					c_pos = i
				end
				
				# add new character to current string
				c_string = c_string + String(line[i])
			
			# else raise error for unknown symbol
			else
				raise UnknownSymbol(line[i], c_line, i)
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

