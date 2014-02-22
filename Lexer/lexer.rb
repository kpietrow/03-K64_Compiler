#!/usr/bin/env ruby

# It's my estimation that  we're gonna be examining incoming input
# here, and translating it with our nice Lexer into some tokens


# TODO: Robust terminal output



# bring in tokenizing functions
require 'rubygems'
require './Lexer/tokenizer.rb'



##
# error for unknown symbols
# exits program, prints line and line number
class UnknownSymbolError < StandardError
	def initialize(char, lineno, pos)
		@char, @lineno, @pos = char, lineno + 1, pos + 1
		puts "ERROR: Line #{@lineno}, Position #{@pos}, Character \'#{char}\' -> This here character don't appear to be known to no-one around these parts."
		exit
	end
end

# Error for early or nonexistent EOF
class EOFDetectionError < StandardError
	def initialize(type, lineno, pos)
		@type, @lineno, @pos = type, lineno + 1, pos + 1
		if @type == "early"
			puts "ERROR: Line #{@lineno}, Position #{@pos} -> EOF reached early at this location. Will now terminate the program."
			exit
		elsif @type == "dne"
			puts "WARNING: No EOF sign ($) reached. Will temporarily add one for this run-through, but the source code will not be altered."
		end
	end
end




def lexer(input)
	# We're gonna run a nice Lexer now
	# Get ourselves some tokens
	
	tokens = []   # Startin' with the input code in a mighty nice array
	c_line = 0    # current line in program
	eof_reached = false   # EOF status
	s_check = false		# for ensuring complete strings
	
	for line in input
		c_string = ""
		c_pos = nil
		
		for i in 0...line.length
		
			# preliminary test for anything after EOF
			if eof_reached and line[i] =~ /\S/
				raise EOFDetectionError.new("early", c_line, i)
			end
		
			# test here for EOF symbol
			if $eof.match(line[i])
				eof_reached = true
				
				# tokenize current string
				if c_string != ""
					tokens.push(tokenize(c_string, "alphanum", c_line, c_pos))
					
					c_string = ""
					c_pos = nil
				end
				
				# tokenize '$'
				tokens.push(tokenize(line[i], "op", c_line, i))
				
			# Testin' for whitespace
			elsif $space.match(line[i])
				if c_string != "" and !s_check
					tokens.push(tokenize(c_string, "alphanum", c_line, c_pos))
					
					c_string = ""
					c_pos = nil
					
				else
					c_string = c_string + String(line[i])
					c_pos = c_pos + 1
				end
			
			# Testin' for operators
			# note: the whitespace issue was handled with the previous elsif
			elsif $operator.match(line[i])
				
				# if op is ", start the string gathering process
				if /"/.match(line[i]) and !s_check
					s_check = true
				
				
					# tokenize c_string if applicable
					if c_string != ""
						tokens.push(tokenize(c_string, "alphanum", c_line, c_pos))
					
						c_string = ""
						c_pos = nil
					end
					
				elsif /"/.match(line[i])
					
					
					s_check = false
					
				else
					# tokenize c_string if applicable
					if c_string != ""
						tokens.push(tokenize(c_string, "alphanum", c_line, c_pos))
					
						c_string = ""
						c_pos = nil
					end
				
				end
				
				
				# attempt to tokenize the operator
				tokens.push(tokenize(line[i], "op", c_line, i))
				
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
				raise UnknownSymbolError.new(line[i], c_line, c_pos)
			end
		end
		
		# increment the line number
		c_line = c_line + 1
	end
	
	# if no EOF symbol ($) detected
	if !eof_reached
		begin
			raise EOFDetectionError.new("dne", 0, 0)
		rescue EOFDetectionError
			tokens.push(tokenize("$", "op", c_line, 0))
		end
	end
	
	# return token list
	return tokens
end