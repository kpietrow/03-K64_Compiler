#!/usr/bin/env ruby

# It's my estimation that  we're gonna be examining incoming input
# here, and translating it with our nice Lexer into some tokens



##
# error for unknown symbols
# exits program, prints line and line number
class UnknownSymbolError < StandardError
	def initialize(char, lineno, pos)
 		@char, @lineno, @pos = char, lineno + 1, pos + 1
 		puts "ERROR: Line #{@lineno}, Position #{@pos}, Character(s) \'#{char}\' -> This here input don't appear to be known to no-one around these parts."
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

# Error class for strings
class StringDetectionError < StandardError
	def initialize(type, char, lineno, pos)
		if type == "unclosed"
			puts "ERROR: Line: #{lineno + 1} -> Unclosed string found on this line."
		elsif type == "char"
			puts "ERROR: Line: #{lineno}, Position: #{pos} -> Unknown character '#{char}' found in string."
		end
		
		exit
	end
end




def lexer(input)
	# We're gonna run a nice Lexer now
	# Get ourselves some tokens
	
	tokens = []   # Startin' with the input code in a mighty nice array
	c_line = 0    # current line in program
	eof_reached = false   # EOF status
	s_check = false		# for ensuring complete strings
	
	c_string = ""	# the current string of chars
	c_pos = nil		# current position of string of chars
	
	# get a line of input
	for line in input
		
		# check characters in line of input
		for i in 0...line.length
			
			puts line[i]
			
			# checks for unfinished strings first
			if s_check
			
				# make sure that we're not going to be using nil for tokenize()
				if c_pos == nil
					c_pos = i
				end
			
				# check the different options
				case line[i]
				
				# found a closing quotation mark
				when /"/
					tokens.push(tokenize(c_string, "string", c_line, c_pos))
					tokens.push(tokenize(line[i], "op", c_line, i))
					c_string = ""
					s_check = false
					
				# space or letter
				when /( )/, /[a-z]/
					c_string = c_string + line[i]
					
				# invalid options
				else
					
					# checks for end of line, else it's a bad character
					if i == line.length - 1
						raise StringDetectionError.new("unclosed", line[i], c_line, i)
					else
						raise StringDetectionError.new("char", line[i], c_line, i)
					end
				end
				
		
			# test for anything after EOF
			elsif eof_reached and line[i] =~ /\S/
				raise EOFDetectionError.new("early", c_line, i)
				exit
			
		
			# test here for EOF symbol
			elsif $eof.match(line[i])
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
				
				# attempt to tokenize the operator
				tokens.push(tokenize(line[i], "op", c_line, i))
				
				# if op is ", start the string gathering process
				if /"/.match(line[i])
					s_check = true
				end
				
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
		
		# check to make sure that all strings on this line are finished
		if s_check
			raise StringDetectionError.new("unclosed", "", c_line, 0)
		end
		
		# check to make sure no current strings are left
		if c_string != ""
			tokens.push(tokenize(c_string, "alphanum", c_line, c_pos))
		end
		
		# reset for next line
		c_string = ""
		c_pos = nil
		
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