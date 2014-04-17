#!/usr/bin/env ruby

# Works with the symbol table

class SymbolTableRepeatError < StandardError
	def initialize (id, token)
		puts "ERROR: ID '#{id}' was declared twice in the same scope. The source code location is Line: #{token.lineno}, Position: #{token.pos}"
		exit
	end
end

class SymbolTableUndeclaredError < StandardError
	def initialize (id, token)
		puts "ERROR: ID '#{id}' was used without being previously declared. The source code location is Line: #{token.lineno}, Position: #{token.pos}"
		exit
	end
end

class SymbolTableReassignmentTypeMismatchError < StandardError
	def initialize (id, token)
		puts "ERROR: ID '#{id}' was reassigned using the wrong type. The source code location is Line: #{token.lineno}, Position: #{token.pos}"
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
	
	def add_symbol (type, id, ast_node, token)
		@current_scope.add_symbol(type, id, ast_node, token)
	end
	
	def update_symbol (type, id, ast_node, token)
		@current_scope.update_symbol(type, id, ast_node, token)
	end
	
	def scan_table_id (id)

		def small_loop(current_scope, id)
			if current_scope.symbols.has_key?(id)
				current_scope.symbols[id].is_used = true
				return true
			elsif current_scope == @root
				return false
			else
				scan_table(current_scope.parent)
			end
		end

		small_loop(@current_scope, id)
	end
	
	
	def raw_print 
		
		puts "The symbol tables of the various scopes: "
		
		def child_loop (scope)
			scope.children.cycle(1) { |child|
				if child.children.length > 0
					child_loop(child.children)
				else
					print " | " + String(child.symbols)
				end
			}
		end
		
		child_loop(@root)
		
	end
	
end


##
# Creates instances of Symbol
# Created to reduce complexity of long arrays
#
class SymbolEntry
	
	attr_accessor :is_used, :is_initialized
	attr_reader :type, :id, :token, :ast_node
	
	@type = nil
	@id = nil
	@ast_node = nil
	@token = nil
	@is_used = false
	@is_initialized = false
	
	def initialize (type, id, ast_node, token)
		
		puts "THE COLE TRAIN BABY"
		
		@type = type
		@id = id
		@ast_node = ast_node
		@token = token
		
	end
	
	def update_symbol (ast_node, token)
		
		@ast_node = ast_node
		@token = token

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
	def add_symbol (type, id, ast_node, token)
		
		if !@symbols.has_key?(token.value)
			@symbols[id] = SymbolEntry.new(type, id, ast_node, token)
		
		# raise error on already defined id's	
		else
			raise SymbolTableRepeatError.new(id, token)
		end
		
	end
	
	def update_symbol (type, id, ast_node, token)
		if @symbols.has_key?(id) and @symbols[id].type == type
			@symbols[id].update_symbol(ast_node, token)
		else
			symbol = scan_table(id)
			if symbol.type == type
				@symbols[id] = symbol.add_symbol(type, id, ast_node, token)
			else
				raise SymbolTableReassignmentTypeMismatchError.new(id, token)
			end
		end
	end
	
	def scan_table (id, token)
		
		def small_loop(scope, id, token)
			if scope.symbols.has_key?(id)
				return scope.symbols[id]
			elsif scope.parent == nil
				raise SymbolTableUndeclaredError.new(id, token)
			else
				small_loop(scope.parent)
			end
		end
		
		return small_loop(self, id, token)
	end
	
	
	def enter (current)
		new_scope = Scope.new(current)
		@children.push(new_scope)
		return new_scope
	end
	
end	
	