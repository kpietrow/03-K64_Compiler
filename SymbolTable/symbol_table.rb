#!/usr/bin/env ruby

# Works with the symbol table

class SymbolTableError < StandardError
	def initialize (id)
		puts "ERROR: Id '#{id}' was declared twice in the same scope"
		exit
	end
end

##
# Creates the Symbol Table
# This mostly just manages the Scope instances
#
class SymbolTable
	
	@root = nil
	@current_scope = nil
	
	def initialize ()
	end
	
	# returns a new layer of scope
	def enter ()
		@current_scope = current_scope.enter(@current_scope)
		
		if @root == nil
			@root = @current_scope
		end
	end
	
	def exit ()
		@current_scope = @current_scope.parent
	end
	
	def add_symbol (type, id)
		@current_scope.add_symbol(type, id)
	end
	
end

class Scope

	@parent = nil
	@children = []
	@symbols = nil
	
	def initialize (parent = nil)
		@symbols = Hash.new
		@parent = parent
		@children = []
	end
	
	# add symbol to symbols table
	def add_symbol (type, id)
		
		if !@symbols.has_key?(id)
			@symbols[id] = type
			
		# raise error on already defined id's
		else
			raise SymbolTableError.new(id)
		end
		
	end
	
end	
	