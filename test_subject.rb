#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies

class C
	attr_accessor :val
	def initialize (val)
		@val = val
	end
end

c = C.new("")
print c.val