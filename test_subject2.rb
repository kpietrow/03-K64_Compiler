#!/usr/bin/env ruby

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