#!/usr/bin/env ruby



# AST class
class AbstractSyntaxTree
	
	attr_reader :current, :total_nodes
	attr_accessor :root
	
	@root = nil
	@current = nil
	
	
	def initialize 
		@root = nil
		@current = nil
	end
	
	
	def ascend 
		
		# just want to be careful
		if @current != @root
			@current = @current.parent
		end
		
	end
	
	# Prints out the AST
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
	
end