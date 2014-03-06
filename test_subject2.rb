#!/usr/bin/env ruby

require './test_subject.rb'

def ultimate_test(index)
	puts "here we go!"
	puts $cr
	puts index
	index = index + 1
end
main1()
ultimate_test(0)
