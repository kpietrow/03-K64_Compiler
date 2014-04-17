#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies
# NOTE: This file should NOT be used for testing the compiler directly

a = "hello you"
a = a.scan(/\w+/)
for i in a
	puts i
end