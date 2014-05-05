#!/usr/bin/env ruby

class Tester

	attr_accessor :id, :others

	@id
	@others = []
	
	def initialize (id)
		@id = id
		@others = []
	end
	
	def add (node)
		@others.push(node)
	end
end

a = Tester.new(1)
b = Tester.new(2)

a.add(b)
puts a.others[0].id
b.id = 3

puts a.others[0].id