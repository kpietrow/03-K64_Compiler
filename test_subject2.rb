#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies
# NOTE: This file should NOT be used for testing the compiler directly

# require './test_subject.rb'

class Tester
	
	@var = nil
	@children = []
	
	def var
		puts @var == nil
	end
	
	def children
		@children = []
		puts @children.is_a? Array
	end
	
end

c = Tester.new
c.var
c.children