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

# Settin' up some basic regex searches now
$integer = /[0-9]/
$string = /[a-zA-z]/
$space = /\$s/
$eof = /\$/

def Token_Check (token)

end

def Lexer(input)
	# We're gonna run a nice Lexer now
	# Get ourselves some tokens
	
	# Startin' with the input code in a mighty nice array
	tokens = []
	
	for line in input
		previous = nil
		current_string = nil
		
		for i in 0...line.length
			if $eof.match(line[0])
				puts "EOF reached, partner"
				
				break
			
			elsif $space.match(line[i])
				if current_string != nil
					tokens = tokenize(current_string)
					current_string = nil
				end
			end
		end
	end
end


def test(input)
	for line in input
		print line
		puts "\n"
	end
	
end

