#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies
# NOTE: This file should NOT be used for testing the compiler directly



def test1
		
	test3(test2)
	
end

def test2
	
	puts "hi"
	
end

def test3 (test)
	
	puts "yo"
	test
	puts "second"

end

test1