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
class UnknownSymbolError < StandardError
	def initialize(char, lineno, pos)
		@char, @lineno, @pos = char, lineno, pos
		puts "ERROR: Line #{lineno}, Position #{pos}, Character \'#{char}\' -> This here character don't appear to be known to no-one around these parts."
		exit
	end
end

# Error for early and nonexistent EOF
class EOFError < StandardError
	def initialize(type, lineno, pos)
		@type, @lineno, @pos = lineno, pos
		if @type == "early"
			puts "ERROR: Line #{lineno}, Position #{pos} -> EOF reached early at this location. Will now terminate the program."
			exit
		elsif @type == "dne"
			puts "WARNING: No EOF sign ($) reached. Will temporarily add one for this run-through, but the source code will not be altered."
		end
	end
end

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
		raise UnknownSymbolError.new(p_token, lineno, pos)
	end
end

# dealing with alphanumeric character strings
def alphanum_tokenize(p_token, lineno, pos)

	# T_ID potential
	if (p_token =~ $character) and (p_token =~ $digit)
		
		# Can't start with a digit
		if p_token[0] =~ $digit
			raise UnknownSymbolError.new(p_token, lineno, pos)
		else
			return Token.new("T_ID", p_token, lineno, pos)
		end
		
	# T_DIGIT. Tokenize its value as an int and not a string
	elsif p_token =~ $digit
		return Token.new("T_DIGIT", Integer(p_token), lineno, pos)
	
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
			raise UnknownSymbolError.new(p_token, lineno, pos)
		end
	else
		raise UnknownSymbolError.new(p_token, lineno, pos)
	end
end

# take in the potential token, type (char/op), lineno, and pos
def tokenize (p_token, type, lineno, pos)
	if type == "op"
		return op_tokenize(p_token, lineno, pos)
	
	elsif type == "alphanum"
		return alphanum_tokenize(p_token, lineno, pos)
	
	end
end

def Lexer(input)
	# We're gonna run a nice Lexer now
	# Get ourselves some tokens
	
	# Startin' with the input code in a mighty nice array
	tokens = []
	
	# current line in program
	c_line = 0
	
	# EOF status
	eof = false
	
	for line in input
		c_string = ""
		c_pos = nil
		
		for i in 0...line.length
			# test here for EOF
			if $eof.match(line[i])
				puts "EOF reached, partner"
				eof = true
				
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
				raise UnknownSymbolError.new(line[i], c_line, i)
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
			raise UnknownSymbolError.new(3, 2, 1)
		else 
			puts "not a t"
		end
	end
end

