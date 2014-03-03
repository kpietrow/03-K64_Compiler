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

tester(test)

print test