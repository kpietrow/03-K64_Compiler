#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies

# require './test_subject2.rb'

def tester (t)
	t.cycle(1) {
	|x| 
		if x[0] == 7
			x.push([10])
		else
			if !x.is_a? Integer
				tester(x)
			end
		end }
end

# print tester(test)


def test1 (a)
	
	def test2 (b)
		puts b
	end

	test2(a)
end

#tester(test)

#print test


class Test1
	attr_accessor :var
	
	@var = nil
	
	def initialize (var)
		@var = var
	end
	
	def var
		@var
	end
end

class Test2
	attr_accessor :var, :collection
	
	@var = nil
	@collection = []
	
	def initialize (var)
		@var = var
		@collection = []
	end
	
	def add (y)
		@collection.push(y)
	end
	
	def collection
		@collection
	end
		
end

def main1

	c = 2
	
	def main2 (var)
		puts var * 2
	end
	
	main2(c)
	
	$cr = "I'm here!"
	
	puts $cr
	
end