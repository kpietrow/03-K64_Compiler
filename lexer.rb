#!/usr/bin/env ruby

# It's my estimation that  we're gonna be examining incoming input
# here, and translating it with our nice Lexer into some tokens


class Token
	# Establishin' a token class for easier categorization
	
	attr_accessor :type, :num_tokens
	
	def initialize(type)
		@type = type
		@@num_tokens = @@num_tokens + 1
	end
end

def Lexer(input)
	# Startin' with the input code in a mighty nice array
	tokens = Array.new
	
	for line in input
		previous = null
		current = null
		
		for i in 0...line.length
			if /\$/.match(line[0])
				puts "EOF reached, partner"
				
				break
			
			elsif /\s/.match(line[0])
				
			
		
	end
	
	
	
end

Lexer