#!/usr/bin/env ruby

# This file is purely for the purposes of testing different strategies

class Temperror < StandardError
	def initialize()
	end
end

c = 8

raise Temperror.new(), "shouldn't have done a string!"