#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies

class Test1
	attr_accessor :num
	
	@@num = 0
	
	def initialize()
		@@num = @@num + 1
	end
end

a = Test1.new()
b = Test1.new()

puts a.num
puts b.num