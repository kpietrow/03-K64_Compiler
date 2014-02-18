#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies

class Temperror < StandardError
	def initialize()
		puts "test"
	end
end

c = 8

raise Temperror.new()