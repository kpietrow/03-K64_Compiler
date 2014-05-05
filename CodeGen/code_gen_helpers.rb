#!/usr/bin/env ruby

class SymbolRepeatError < StandardError
	def initialize (symbol)
		puts "ERROR: Symbol '#{symbol}' was incorrectly received while making the static table"
		exit
	end
end


class StaticTable
	
	@temp_address
	@offset
	@entries
	
	def initialize
		@temp_address = 0
		@offset = 0
		@entries = Hash.new
	end
	
	def add (symbol)
		
		if @entries[symbol]
			raise SymbolRepeatError.new(symbol)
		end
		
		address = "T" + String(@temp_address + 1).to_s(16)
		
	end
	
	
end