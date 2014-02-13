#!/usr/bin/env ruby

# central file

require 'io/console'

require './lexer.rb'

class BlankFileException < RuntimeError
	def initialize()
		puts "ERROR: There don't seem to be any information in that here file. We're just gonna exit the program for ye."
		exit
	end
end

def main
# He's going to be running this operation
	
	# Retrieving that shiny input file
	input_file = File.new(ARGV[0])
	
	# Sortin' out them good lines from the bad
	input_file = IO.readlines(input_file)
	
	if input_file.length == 0
		raise BlankFileException
	end
	
	token_stream = test(input_file)
	
end

main