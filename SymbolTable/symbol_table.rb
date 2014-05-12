#!/usr/bin/env ruby

# Works with the symbol table

class SymbolTableRepeatError < StandardError
	def initialize (id, line)
		puts "ERROR: ID '#{id}' was declared twice in the same scope. The source code location is Line: #{line + 1}"
		exit
	end
end

class SymbolTableUndeclaredError < StandardError
	def initialize (id, line)
		puts "ERROR: ID '#{id}' was used without being previously declared. The source code location is Line: #{line + 1}"
		exit
	end
end

class SymbolTableUninitialzedIdUseError < StandardError
	def initialize (id, line)
		puts "ERROR: ID '#{id}' was used on Line: #{line + 1} without prior initialization"
		exit
	end
end

class SymbolTableReassignmentTypeMismatchError < StandardError
	def initialize (e_type, r_type, id, line)
		puts "ERROR: ID '#{id}' was reassigned using the wrong type, a(n) '#{r_type}' instead of a(n) '#{e_type}'. The source code's location is Line: #{line + 1}"
		exit
	end
end

class UnusedIdentifierWarning < StandardError
	def initialize (type, id, scope)
		puts "WARNING: The ID '#{type}:#{id}' was initialized in scope #{scope}, but never used"
	end
end

class UninitializedIdentifierWarning < StandardError
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
	
		puts self.display_scope_path + "Creating new scope..."
		
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
		
		symbol = SymbolEntry.new(name, type, line, @current_scope.scope_number)
		
		if @current_scope.symbols[name]
			raise SymbolTableRepeatError.new(name, line)
			
		else
			@current_scope.add(name, symbol)
		end
	
	end
	
	def get_symbol (name, line)
	
		scope = @current_scope
		
		while scope
			symbol = scope.symbols[name]
			
			if symbol
				return symbol
			else
				scope = scope.parent
			end
		end
		
		raise SymbolTableUndeclaredError.new(name, line)
		
	end
	
	
	def current_scope
		@current_scope
	end
	
	def root
		@root
	end
	
		
	def ascend
		output = self.display_scope_path
		if output.length > 3
			output = output[0..output.length - 4]
		else
			output = ""
		end
		puts output + "Leaving a scope..."
		
		
		if @current_scope != @root
			@current_scope = @current_scope.parent
		end
				
	end
	
	
	def analysis (node)
	
		symbols = node.symbols
		
		for symbol in symbols
			symbol = symbol[1]
			
			if !symbol.is_initialized
				begin
					raise UninitializedIdentifierWarning.new(symbol.type, symbol.name, node.scope_number)
				rescue UninitializedIdentifierWarning
				end
			elsif !symbol.is_used
				begin
					raise UnusedIdentifierWarning.new(symbol.type, symbol.name, node.scope_number)
				rescue UnusedIdentifierWarning
				end
			end
			
			for child in node.children
				analysis(child)
			end
			
		end
	end
	
	#######
	# Displays the current scope path
	#
	def display_scope_path
		
		if @current_scope != nil
			node = @current_scope
			printout = String(node.scope_number) + "> "
			
			while node.parent != nil
				node = node.parent
				printout = String(node.scope_number) + "> " + printout
			end
			
			return printout
		else
			return ""
		end 
		
	end
	
	
	def printout

		puts "The symbol tables of the various scopes: "

		def child_loop (scope)
			if scope.symbols.length > 0
				print "{" + String(scope.scope_number) + "| "
				scope.symbols.each {|child| 
					print "#{child[1].type}:#{child[1].name} "
				}
				print "} "
			end
			
			scope.children.each {|child| child_loop(child)}
		end

		child_loop(@root)

	end
	
	
	
	
end


##
# Creates Scope instances
# Each Scope has a Hash table of symbols
#
class Scope

	attr_accessor :symbols, :parent, :children
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
	attr_accessor :is_used, :is_initialized

	@name = nil
	@type = nil
	@line = nil
	@scope_level = nil
	@is_used = false
	@is_initialized = false
	
	def initialize  (name, type, line, scope_level)
		@name = name
		@type = type
		@line = line
		@scope_level = scope_level
		
		@is_used = false
		@is_initialized = false
	end

end


	