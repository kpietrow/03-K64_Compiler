#!/usr/bin/env ruby

# central file

require 'io/console'

def main
# He's going to be running this operation
	
	# Retrieving that shiny input file
	input_file = File.new(ARGV[0])
	
	# Sortin' out them good lines from the bad
	input_file = IO.readlines(input_file)
	puts input_file
	
	
end

main