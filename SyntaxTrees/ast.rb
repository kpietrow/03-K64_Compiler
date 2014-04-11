#!/usr/bin/env ruby



# CST tree class
class AST
	
	attr_reader :current, :total_nodes
	
	@@total_nodes = 0
	@root = nil
	@current = nil
	
	
	def initialize 
		@root = nil
		@current = nil
	end
	
	# add a node
	def add_branch (name)
	
		@@total_nodes = @@total_nodes + 1
		
		# if there are no nodes yet, start it off!
		if @root == nil
			@root = Node.new("branch", name)
			@current = @root
		
		# otherwise, move about this intelligently
		else
			@current.add_child("branch", name)
			@current = @current.children[@current.children.length - 1]
		end
	end
	
	def add_leaf (name, token)
	
		@@total_nodes = @@total_nodes + 1
		
		# if there are no nodes yet, start it off!
		if @root == nil
			raise EarlyLeafError.new(token)
		
		# otherwise, move about this intelligently
		else
			@current.add_child("leaf", name, token)
		end
		
	end
	
	def ascend 
		
		# just want to be careful
		if @current != @root
			@current = @current.parent
		end
		
	end
	
	# Prints out the very basic details of the AST
	def raw_print 
		
		puts "The nodes in the constructed AST: "
		
		def small_loop (first)
		
			if first == @root
				print " (" + @root.name + ") "
			end
		
			if first.type == "branch"
				print " ("
				first.children.cycle(1) { |child| print child.name + " " }
				print ") "
				first.children.cycle(1) { |child| small_loop(child) }
			end
		
		end
		
		small_loop(@root)
		
	end
	
end