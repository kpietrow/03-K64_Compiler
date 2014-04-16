#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies
# NOTE: This file should NOT be used for testing the compiler directly

total = 0
a = []
		
def looper (list)
	# remember, we only support + in this grammar
	list.cycle(1) { |child|
		if child[0] == 4
			total = total + Integer(child[1])
		end
	}
	
end	

#looper(a)

b = Hash.new
b["a"] = [100, 200]
puts b["a"]