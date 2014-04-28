#!/usr/bin/env ruby

# Works with the symbol table

class SymbolTableRepeatError < StandardError
	def initialize (id, token)
		puts "ERROR: ID '#{id}' was declared twice in the same scope. The source code location is Line: #{token.lineno + 1}"
		exit
	end
end

class SymbolTableUndeclaredError < StandardError
	def initialize (id, token)
		puts "ERROR: ID '#{id}' was used without being previously declared. The source code location is Line: #{token.lineno + 1}"
		exit
	end
end

class SymbolTableReassignmentTypeMismatchError < StandardError
	def initialize (e_type, r_type, id, token)
		puts "ERROR: ID '#{id}' was reassigned using the wrong type, a(n) '#{r_type}' instead of a(n) '#{e_type}'. The source code's location is Line: #{token.lineno + 1}"
		exit
	end
end

class UnusedIdentifierError < StandardError
	def initialize (type, id, scope)
		puts "WARNING: The ID '#{type}:#{id}' was initialized in scope #{scope}, but never used"
	end
end

class UninitializedIdentifierError < StandardError
	def initialize (type, id, scope)
		puts "WARNING: The ID '#{type}:#{id}' was created in scope #{scope}, but never initialized"
	end
end



##
# Creates the Symbol Table
# This mostly just manages the Scope instances
#
class SymbolTable
	
	@global_scope_number = nil
	@root = nil
	@current_scope = nil

	
	def initialize
		@global_scope_number = -1
		@current_scope = nil
		@root = nil
	end
	
	def create_scope
		@global_scope_number += 1
		new_scope = Scope.new(@global_scope_number)
		new_scope.parent = @current_scope
		
		if @global_scope_number == 0
			@root = new_scope
			@current_scope = @root
		else
			@current_scope.children.push(new_scope)
			@current_scope = new_scope
		end
			
	end
	
	def add_symbol (name, type, line)
		
		symbol = SymbolEntry.new(name, type, line, @current_scope.scope_level)
		@current_scope.add(name, symbol)
	
	end
	
	def get_symbol (name)
	
		scope = @current_scope
		
		while node
			symbol = scope.symbols[name]
			
			if symbol
				return symbol
			else
				node = node.parent
			end
		end
		
		return nil
		
	end
	
	
	def ascend
		
		if @current_scope != @root
			@current_scope = @current_scope.parent
		end
		
	end
	
	
	
end


##
# Creates Scope instances
# Each Scope has a Hash table of symbols
#
class Scope

	attr_accessor :symbols, :parent
	attr_reader :scope_number

	@scope_number = nil
	@symbols = nil
	@children = []
	@parent = nil
	
	def initialize (number)
		@scope_number = number
		@symbols = Hash.new
		@children = []
	end
	
	def add (name, symbol)
		@symbols[name] = symbol
	end
	
	def get (name)
		
		if @symbols[name]
			return @symbols[name]
		else
			return nil
		end
		
	end
	
end	



##
# Creates instances of Symbol
# Created to reduce complexity of long arrays
#
class SymbolEntry

	attr_reader :name, :type, :line, :scope_level

	@name = nil
	@type = nil
	@line = nil
	@scope_level = nil
	
	def initialize  (name, type, line, scope_level)
		@name = name
		@type = type
		@line = line
		@scope_level = scope_level
	end

end


	