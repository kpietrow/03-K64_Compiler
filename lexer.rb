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

def Token_Check (token)

end

def Lexer(input)
	# Startin' with the input code in a mighty nice array
	tokens = []
	
	for line in input
		previous = nil
		current = nil
		
		for i in 0...line.length
			if /\$/.match(line[0])
				puts "EOF reached, partner"
				
				break
			
			elsif /\s/.match(line[0])
			end
		end
	end
end


def test
	puts "lexer accessed"
end

test