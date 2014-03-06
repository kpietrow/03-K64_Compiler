#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies
# NOTE: This file should NOT be used for testing the compiler directly


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
	attr_accessor :var, :var2, :collection
	
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
	
	def change (test)
		test.var = self.var
	end
	
	def test
		self
	end
		
end

def main1

	a = Test2.new("hi")
	b = Test2.new("hello")
	puts a.test
	puts b.var
	
end



def besttest
	
	besttest2()
	
	def besttest2
		puts "hi"
	end
end

besttest