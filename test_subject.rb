#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies

class Test1
	
	
	@@num = 0
	
	def initialize()
		@@num = @@num + 1
	end
	
	def post
		puts @@num
	end
end

a = Test1.new()
b = Test1.new()

puts a.post()
puts b.post()