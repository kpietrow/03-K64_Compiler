#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies

class Test1
	
	
	@@num = 0
	
	def initialize
	end
	
	def num
		@@num
	end
end

b = Test1.new
c = []
c.push([b])
print c[0][0].num