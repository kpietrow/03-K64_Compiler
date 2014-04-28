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
	
	# Prints out the very basic details of the AST
	def raw_print 
		
		puts "The nodes in the constructed AST: "
		
		def small_loop (first)
		
			
			if @root == nil
				puts "This AST is currently empty"
				return
			elsif first == @root
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
	
	def root
		@root
	end
	
end