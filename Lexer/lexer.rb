#!/usr/bin/env ruby

###################################################
# This is the Lexer of the 03-K64 Compiler.
# Crafted for Alan's 'Design Compilers' class,
# lovingly coded in Ruby magic, and narrated by
# her captain.
#
#
# Author: Kevin Pietrow
# Version: The shiny one
# 
# Note: Instructions for running the best compiler
# 		in the Verse can be found in the README
#





###################################################
# Declaring all relevant errors here
#

# error for unknown symbols
class UnknownSymbolError < StandardError
	def initialize(char, lineno, pos)
 		@char, @lineno, @pos = char, lineno + 1, pos + 1
 		puts "-------------------------------------------------------------------"
 		puts "ERROR: Line #{@lineno}, Position #{@pos}, Character(s) \'#{char}\' -> This here input don't appear to be known to no-one around these parts."
 		puts "-------------------------------------------------------------------"
 		exit	
 	end
end

# Error for early or nonexistent EOF
class EOFDetectionError < StandardError
	def initialize(type, lineno, pos)
 		@type, @lineno, @pos = type, lineno + 1, pos + 1
 		if @type == "early"
 			puts "-------------------------------------------------------------------"
 			puts "ERROR: Line #{@lineno}, Position #{@pos} -> EOF reached early at this location. Will now terminate the program."
 			puts "-------------------------------------------------------------------"
 			exit
 		elsif @type == "dne"
 			puts "-------------------------------------------------------------------"
 			puts "WARNING: No EOF sign ($) reached. Will temporarily add one for this run-through, but the source code will not be altered."
 			puts "-------------------------------------------------------------------"
 		end
 	end
end

# Error class for strings
class StringDetectionError < StandardError
	def initialize(type, char, lineno, pos)
		if type == "unclosed"
			puts "-------------------------------------------------------------------"
			puts "ERROR: Line: #{lineno + 1} -> Unclosed string found on this line."
			puts "-------------------------------------------------------------------"
		elsif type == "char"
			puts "-------------------------------------------------------------------"
			puts "ERROR: Line: #{lineno}, Position: #{pos} -> Unknown character '#{char}' found in string."
			puts "-------------------------------------------------------------------"
		end
		
		exit
	end
end



###################################################
# This here is the main body of the Lexing operations
#

def lexer(input)
	# We're gonna run a nice Lexer now
	# Get ourselves some tokens
	
	tokens = []   # Startin' with the input code in a mighty nice array
	c_line = 0    # current line in program
	special_case = false
	
	c_string = ""	# the current string of chars
	c_pos = nil		# current position of string of chars
	
	# get a line of input
	for line in input
		
		# check characters in line of input
		for i in 0...line.length
		
			# checks for special cases
			if special_case
			
				last_token = tokens[tokens.length - 1]
				
				# Early EOF
				if last_token == "T_EOFSIGN" and line[i] =~ /\S/
				
					raise EOFDetectionError.new("early", c_line, i)
				
				# Boolop
				elsif last_token == "T_BOOLOP"
				
					special_case = false
					next
				
				# String time!
				elsif last_token == "T_QUOTE"
				
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
					when /( )/, $character
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
				end
			
		
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
					tokens.push(tokenize(c_string, "character", c_line, c_pos))
					
					c_string = ""
					c_pos = nil
				end
				
				# test for that elusive boolop...
				# make sure we don't access a non-existent item...
				if i != line.length - 1
					if /[!|=]/.match(line[i]) and /=/.match(line[i + 1])
						# attempt to tokenize the operator
						tokens.push(tokenize(line[i] + line[i + 1], "op", c_line, i))
						special_case = true
					else
						tokens.push(tokenize(line[i], "op", c_line, i))
					end
				else
					tokens.push(tokenize(line[i], "op", c_line, i))
				end
				
				# if op is ", start the string gathering process
				if /"/.match(line[i])
					special_case = true
				end
				
			# Testin' for alpha numeric characters
			elsif $character.match(line[i])
				# set position of current string
				if c_string == "" and c_pos == nil
					c_pos = i
				end
				
				# add new character to current string
				c_string = c_string + String(line[i])
				
			elsif $digit.match(line[i])
			
				# test for more than one digit
				# make sure we don't access a non-existent item...
				if i != line.length - 1
					if $digit.match(line[i + 1])
						raise UnknownSymbolError(line[i + 1], line, i)
					end
				end
				
				tokens.push(tokenize(line[i], "digit", line, i)
			
			# else raise error for unknown symbol
			else
				raise UnknownSymbolError.new(line[i], c_line, c_pos)
			end
		end
		
		
		# check for loose ends
		if special_case
		
			# check to make sure that all strings on this line are finished
			if tokens[length - 1] == "T_QUOTE" or tokens[length - 1] == "T_STRING"
				raise StringDetectionError.new("unclosed", "", c_line, 0)
			
			# if boolop, reset special_case
			elsif tokens[length - 1] == "T_BOOLOP"
				special_case = false
			end
		
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