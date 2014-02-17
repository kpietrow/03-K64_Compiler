#!/usr/bin/env ruby

# testing options

$c = "while"

d = ["hiwhileyo", "while", "hiwhile", "whilego"]
=begin
for i in d
	case i
	when /\b(while)\b/
		puts "good!"
	when /(while)/
		puts "bad"
	when "while"
		puts "ok"
	else
		puts i
	end
end

for i in 0..3
	case i
	when i == 0
		puts "0"
	when i == 1
		puts "1"
	when i == 3
		puts "3"
	else
		puts "no"
	end
end
=end
#c = "h6y"
#d = "het"
#if c =~ /[a-z]/ and c=~ /[0-9]/
#	puts "yeah! 1"
#else
#	puts "no"
#end
#if d =~ /[a-z]/ and c=~ /[0-9]/
#	puts "yeah! 2"
#else
#	puts "no"
#end
