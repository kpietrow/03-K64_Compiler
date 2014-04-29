#!/usr/bin/env ruby


# CST class
class ConcreteSyntaxTree
	
	attr_reader :total_nodes
	
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
			@root = CSTNode.new("branch", name)
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
	
	
	# Prints out the CST
	def printout
		
		index = 0
		
		def small_loop (node, index)
			
			for i in 0...index
				print " "
			end
			
			puts node.name
			index += 1
			
			if node.children.length > 0
				index += 1
				node.children.cycle(1) { |child| small_loop(child, index) }
			end
		end
		
		small_loop(@root, index)
	end
			
	
	
	
	
	def root
		@root
	end
	
	
	def current	
		@current
	end
	
end