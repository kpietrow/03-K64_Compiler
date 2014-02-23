#!/usr/bin/env ruby
# Code for tokenizing functions



class Token
	# Establishin' a token class for easier categorization
	
	attr_accessor :type, :value, :line, :position, :total_tokens
	
	def initialize(type, value, line, pos)
		@type, @value, @line, @pos = type, value, line, pos
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
	
	elsif type == "string"
		return string_tokenize(p_token, lineno, pos)
	end
end