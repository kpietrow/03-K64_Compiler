#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies
# NOTE: This file should NOT be used for testing the compiler directly

# require './test_subject.rb'

b = "!="
c = "="

def main (a)
if /[!|=]/.match(a[0]) and /[=]/.match(a[1])
	puts a[0] + a[1]
else
	puts "oh"
end
end

main(b)
main(c)