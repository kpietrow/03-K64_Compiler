#!/usr/bin/env ruby

class SymbolRepeatError < StandardError
	def initialize (symbol)
		puts "ERROR: Symbol '#{symbol}' was incorrectly received while making the static table"
		exit
	end
end

class JumpTableError < StandardError
	def initialize
		puts "ERROR: Too many jump entries in use."
		exit
	end
end

class CodeOverflowError < StandardError
	def initialize
		puts "ERROR: Too much code given for current block size."
		end
	end
end


###################################################
# Class for the collection, organization, and 
# smugglin' duties of the machine code generation
#
class Code

	attr_accessor :code, :current_address, :heap, :heap_address

	# main body of code
	@code = []
	@current_address = 0
	
	# the heap itself. will grow up, reflecting variables being
	# added in at its end
	@heap = []
	
	# end of the heap
	@heap_address = 255
	
	def initialize
	end
	
	def add (codes)
	
		if codes.is_a? Array
			for code in codes
				# Eliminate illegal characters. Not that there's anything
				# wrong with something in the Verse being illegal, that is
				code = code.gsub(/[^TJA-F0-9]/, "")
				for i in 0...code.length
					section = code[i..i+1]
					section = prepad(section, 2, "0")
					@code.push(section)
					@current_address += 1
				end
			end
		else
			codes = codes.gsub(/[^TJA-F0-9]/, "")
			for i in 0...codes.length
				section = codes[i..i+1]
				section = prepad(section, 2, "0")
				@code.push(section)
				@current_address += 1 
			end
		end
		
	end
	
	def add_string (string)
	
		@heap.unshift("00")
		
		string.length.downto(0) do |i|
			@heap.unshift(hex_converter(string, 2)) 
		end
		
		@heap_address -= string.length + 1
		
		return @heap_address
	
	end
	
	
	def backpatch
		
		for i in 0...@code.length
			word = @code[i]
			
			if /T/.match(word)
				temp_address = word + @code[i + 1]
				entry = $static_table.get(temp_address)
				@code[i] = hex_converter((@current_address + entry.offset), 2)
				@code[i + 1] = "00"
			elsif /J/.match(word)
				entry = $jump_table.get(word)
				this.code[i] = hex_converter(String(entry.distance), 2)
			end
		end
	end
	
	
	def printout
	
		# copy @code
		code = @code.map(&:dup)
		
		while code.length + @heap.length < 255
			code.push("00")
		end
		
		code = code.concat(@heap)
		
		if code.length > 255
			raise
	
	end

end


############################
# Some helper functions
#
#

def prepad (string, length, character = " ")

	while string.length < length
		string = character + string
	end
	
	return string 

end

def pad (string, length, character = " ")

	while (string.length < length)
		string += character
	end
	
	return string

end

def hex_converter (string, prepad_amount = 0)

	hex = ""
	string = string.prepad(string, prepad_amount, '0')

	string.each_byte do |char|
		hex += (char.upcase).to_s(16)
	end
	
	return hex

end


###################################################
# Jump table time!
#
class JumpTable

	attr_reader :entries, :last_entries

	@temp_address = 0
	@last_entries = []
	@entries = {}
	@num_entries = 0
	
	def initialization
	end
	
	def add (current_address)
	
		if temp_address > 9
			raise JumpTableError.new
		end
		
		address = "J" + String(@temp_address)
		jump = JumpTableEntry.new(current_address, address)
		@temp_address += 1
		@last.entries.push(jump)
		@entries[address] = jump
		return jump
	
	end
	
	def set_last (current_address)
	
		last_entry = @last_entries.pop
		last_entry.distance = current_address - last_entry.first_address - 2
	
	end
	
	def get (key)
		return @entries[key]
	end
	
end


class JumpTableEntry 

	attr_accessor :distance
	attr_reader :first_address, :address
	
	@first_address
	@address
	@distance = nil
	
	def initialize (first_address, address)
		@first_address = first_address
		@address = address
	end
	
end



###################################################
# Class that will house and maintain the static 
# table for the code generation part of this
# compiler
#
class StaticTable
	
	attr_accessor :temp_address, :offset, :entries
	
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
		
		address = "T" + (@temp_address + 1).to_s(16)
		@temp_address += 1
		entry = StableTableEntry.new(symbol, address, offset)
		@offset += 1
		entries[symbol.name] = entry
		return entry
		
	end
	
	def get (key)
	
		if key.is_a? SymbolEntry
			return @entries[key.name]
		else
			return @entries[key]
		end
		
	end
	
end


###################################################
# An entry in the static table
#

class StaticTableEntry

	attr_reader :symbol, :address, :offset
	
	@symbol
	@address
	@offset
	
	
	def initialize (symbol = nil, address = nil, offset = nil)
		@symbol = symbol
		@address = address
		@offset = offset
	end
	
end

