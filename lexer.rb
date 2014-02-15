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
$digit = /[0-9]/
$character = /./
$space = /\$s/
$eof = /\$/

def tokenizer (token)

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
			if $eof.match(line[i])
				puts "EOF reached, partner"
				if current_string != nil
					tokens.push(tokenize(current_string))
				end
				break
			
			elsif $space.match(line[i])
				if current_string != nil
					tokens.push(tokenize(current_string))
					current_string = nil
				end
			else
				current_string = current_string + String(line[i])
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

