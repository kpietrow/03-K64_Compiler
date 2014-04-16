#!/usr/bin/env ruby

# Works with the symbol table

class SymbolTableTypeError < StandardError
	def initialize (id)
		puts "ERROR: ID '#{id}' was declared as two different types in the same scope"
		exit
	end
end

class SymbolTableUndeclaredError < StandardError
	def initialize (id)
		puts "ERROR: ID '#{id}' was used without being previously declared"
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
	
	def initialize 
	end
	
	# returns a new layer of scope
	def enter 
		
		if @root == nil
			new_scope = Scope.new
			@root = new_scope
			@current_scope = @root
			
		else
			@current_scope = @current_scope.enter(@current_scope)
		end
	end
	
	def exit 
		@current_scope = @current_scope.parent
	end
	
	def add_symbol (type, id)
		@current_scope.add_symbol(type, id)
	end
	
	def raw_print 
		
		puts "The symbol tables of the various scopes: "
		
		def child_loop (children)
			children.cycle(1) { |child|
				if child.children.length > 0
					child_loop(child.children)
				else
					print " | " + String(child.symbols)
				end
			}
		end
		
		print @root.symbols
		child_loop(@root.children)
		
	end
	
	def scan_table (id)
		
		def small_loop(current_scope, id)
			if current_scope.symbols.has_key?(id)
				return true
			elsif current_scope == @root
				return false
			else
				scan_table(current_scope.parent)
			end
		end
		
		small_loop(@current_scope, id)
	end
	
end


##
# Creates Scope instances
# Each Scope has a Hash table of symbols
#
class Scope

	attr_accessor :children, :symbols
	attr_reader :parent, :test

	@parent = nil
	@children = []
	@symbols = nil
	
	def initialize (parent = nil)
		@symbols = Hash.new
		@parent = parent
		@children = []
	end
	
	# add symbol to symbols table
	def add_symbol (type, token)
		
		if !@symbols.has_key?(token.value)
			@symbols[token.value] = [type, token]
			
		# raise error on already defined id's
		elsif @symbols.has_key?(token.value) and @symbols[token.value][0] == type
			@symbols[token.value] = [type, token]
			
		else
			raise SymbolTableTypeError.new(id)
		end
		
	end
	
	def enter (current)
		new_scope = Scope.new(current)
		@children.push(new_scope)
		return new_scope
	end
	
end	
	