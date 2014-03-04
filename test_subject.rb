#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies

test = [[1],[2, [4],[5, [6], [7]]],[3,[8],[9]]]

found = false


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
	@var = nil
	
	def initialize (var)
		@var = var
	end
	
	def var
		@var
	end
end

class Test2
	attr_accessor :var
	
	@var = nil
	
	def initialize (var)
		@var = var
	end
end

a = [2, [3]]
b = 5

puts a.is_a? Array
puts a[0].is_a? Array
puts a[1].is_a? Array