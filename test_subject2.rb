#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies
# NOTE: This file should NOT be used for testing the compiler directly

# require './test_subject.rb'

class Test1
	
	attr_accessor :var
	
	def initialize
	end
	
	def plan ()
		c = Test2.new()
		c.change()
		puts c.var
	end 
end

class Test2
	
	attr_accessor :var
	
	@var = nil
	
	def initialize ()
		@var = "hi"
	end
	
	def change ()
		@var = "hello"
	end
end

a = Test1.new
a.plan()