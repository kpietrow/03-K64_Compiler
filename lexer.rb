#!/usr/bin/env ruby

# It's my estimation that  we're gonna be examining incoming input
# here, and translating it with our nice Lexer into some tokens


class Token
	# Establishin' a token class for easier categorization
	
	attr_accessor :type, :line, :num_tokens
	
	def initialize(type, line)
		@type = type
		@line = line
		@@num_tokens = @@num_tokens + 1
	end
end

class UnknownSymbol < RuntimeError
	def initialize(lineno, pos)
		puts "ERROR: This here character don't appear to be known to no-one around these parts."
		exit
	end
end



# Settin' up some basic regex searches now
$digit = /[0-9]/
$alpha_numeric = /[a-zA-Z0-9]/
$character = /[a-zA-Z]/
$space = /\s/
$eof = /\$/
# note, this here includes whitespace, so be careful where it's used
$operator = /\W/

def tokenizer (token)

end

def Lexer(input)
	# We're gonna run a nice Lexer now
	# Get ourselves some tokens
	
	# Startin' with the input code in a mighty nice array
	tokens = []
	
	# current line in program
	c_line = 0
	
	for line in input
		previous = nil
		current_string = nil
		
		for i in 0...line.length
			# test here for EOF
			if $eof.match(line[i])
				puts "EOF reached, partner"
				if current_string != nil
					test, token = tokenize(current_string)
					if test
						tokens.push(token)
					end
					current_string = nil
				end
				break
				
			# Testin' for whitespace
			elsif $space.match(line[i])
				if current_string != nil
					test, token = tokenize(current_string)
					if test
						tokens.push(token)
					end
					current_string = nil
				end
			
			# Testin' for operators
			# note: the whitespace issue was handled with the previous elsif
			elsif $operator.match(line[i])
				
				# tokenize current_string if applicable
				if current_string != nil
					tokens.push(tokenize(current_string))
					current_string = nil
				end
				
				tokens.push(tokenize(line[i]))

			elsif
				current_string = current_string + String(line[i])
			end
		end
		
		# increment the line number
		c_line = c_line + 1
	end
end


def test(input)
	for line in input
		print line
		puts "\n"
	end
	
end

