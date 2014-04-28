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
		
	@root = nil
	@current_scope = nil
	@@current_scope_number = nil
	
	def initialize 
		@@current_scope_number = -1
	end
	
	# returns a new layer of scope
	def enter 
		
		if @root == nil
			@@current_scope_number = 0
			new_scope = Scope.new(@@current_scope_number)
			@root = new_scope
			@current_scope = @root
			
		else
			@@current_scope_number += 1
			@current_scope = @current_scope.enter(@@current_scope_number, @current_scope)
		end
	end
	
	def exit 
		@current_scope = @current_scope.parent
		@@current_scope_number -= 1
	end
	
	def add_symbol (type, id, ast_node, token)
		@current_scope.add_symbol(type, id, ast_node, token)
	end
	
	def update_symbol (type, id, ast_node, token, cst_node)
		@current_scope.update_symbol(type, id, ast_node, token)
	end
	
	def scan_table_used (id)

		def small_loop(current_scope, id)
			if current_scope.symbols.has_key?(id)
				current_scope.symbols[id].is_used = true
				return true
			elsif current_scope == @root
				return false
			else
				scan_table_used(current_scope.parent, id)
			end
		end

		small_loop(@current_scope, id)
	end
	
	def retrieve_type (id)

		def small_loop(current_scope, id)
			if current_scope.symbols.has_key?(id)
				current_scope.symbols[id].is_used = true
				return current_scope.symbols[id].type
			elsif current_scope == @root
				return false
			else
				retrieve_type(current_scope.parent, id)
			end
		end

		small_loop(@current_scope, id)
	end
	
	
		
	def raw_print 

		puts "The symbol tables of the various scopes: "

		def child_loop (scope)
			print "{"
			scope.symbols.each {|child| 
				print "#{child[1].type}:#{child[1].id} "
			}
			print "}"
			scope.children.each {|child| child_loop(child)}
		end

		child_loop(@root)

	end
		
		
	
	def c_scope
		if @@current_scope_number != nil
			
			printable = ""
			for i in 0..@@current_scope_number
				printable = printable + String(i) + "-> "
			end
			return printable
		else
			return ""
		end
	end
	
	def analysis 
		
		puts "Analyzing the symbol table: "
		
		def child_loop (scope, scope_num)
			scope.symbols.each {|child| 
				if !child[1].is_initialized
					begin
						raise UninitializedIdentifierError.new(child[1].type, child[1].id, scope_num)
					rescue UninitializedIdentifierError
					end
				end
				if !child[1].is_used and child[1].is_initialized
					begin
						raise UnusedIdentifierError.new(child[1].type, child[1].id, scope_num)
					rescue UnusedIdentifierError
					end
				end
			}
			scope.children.each {|child| child_loop(child, scope_num + 1)}
		end
		
		child_loop(@root, 0)
		
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
		
		@type = type
		@id = id
		@ast_node = ast_node
		@token = token
		
	end
	
	def update_symbol (ast_node, token)
		
		@ast_node = ast_node
		@token = token

	end
	
	def id
		@id
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
	@scope_number = 0
	
	def initialize (current_scope_number, parent = nil)
		@scope_number = current_scope_number
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
	
	def update_symbol (expected_type, id, ast_node, token)
		if @symbols.has_key?(id) and @symbols[id].type == expected_type
			@symbols[id].update_symbol(ast_node, token)
			@symbols[id].is_initialized = true
		else
			symbol = scan_table(id, token)
			if symbol.type == expected_type
				@symbols[id] = SymbolEntry.new(expected_type, id, ast_node, token)
				@symbols[id].is_initialized = true
			else
				raise SymbolTableReassignmentTypeMismatchError.new(symbol.type, expected_type, id, token)
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
				small_loop(scope.parent, id, token)
			end
		end
		
		return small_loop(self, id, token)
	end
	
	
	def enter (current_scope_number, current)
		new_scope = Scope.new(current_scope_number, current)
		@children.push(new_scope)
		return new_scope
	end
	
end	
	