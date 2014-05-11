#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies
# NOTE: This file should NOT be used for testing the compiler directly

a = "y"
a.each_byte do |c|
	puts c
	puts c.to_s(16)
end