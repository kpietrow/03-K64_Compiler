#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies
# NOTE: This file should NOT be used for testing the compiler directly

##
# Creates instances of Symbol
# Created to reduce complexity of long arrays
#
class SymbolEntry

	attr_reader :type, :line, :scope_level
	attr_accessor :name

	@name
	@type
	@line
	@scope_level
	
	def initialize  (name, type, line, scope_level)
		@name = name
		@type = type
		@line = line
		@scope_level = scope_level
	end
	
	
	
	
	
end

a = SymbolEntry.new("hi", "yo", 7, 9)
b = SymbolEntry.new(a, "hello", 5, 6)

c = Hash.new
c["hi"] = 5

if c["hello"]
	puts "hello there"
else
	puts "failed correctly"
end