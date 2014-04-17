#!/usr/bin/env ruby



# AST class
class AbstractSyntaxTree
	
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
		
		
=begin	
		spaces = (self.total_nodes / 2) + 30

		def small_loop (nodes, spaces)
		
			if @root == nil
				puts "This AST is currently empty"
				return
			elsif nodes == @root
				for i in 0..spaces
					print " "
				end
				puts "(" + @root.name + ") "
				
				for i in 0..spaces + 3
					print " "
				end
				puts "|"
				
				spaces = spaces - ((nodes.children.length / 2) * 8)
				
				for i in 0..spaces
					print " "
				end
				print " ("
				for child in nodes.children
					print child.name + " "
				end
				puts ") \n\n"
				
				next_nodes = []
				
				for child in nodes.children
					next_nodes.push(child)
				end
				
				small_loop(next_nodes, spaces)
				
				return
			end
		
			#if nodes.type == "branch"
			if 1 == 1	
				#for i in 0...nodes.children.length
					#for child in node.children
					#	new_spaces = spaces - ((node.children.length / 2) * 8) + (i * 7)
					#	if i == 0
					#		for y in 0..spaces + 3
					#			print " "
					#		end
					#		puts "|"
					#		nodes.children
					#	
					#	new_children.push(child.children)
					#	end
					#end
				end
				
				for y in 0..spaces + 3
					print " "
				end
				puts "|"
				
				spaces = spaces - ((node.children.length / 2) * 8)
				
				for i in 0..spaces
					print " "
				end
				print " ("
				for child in node.children
					print child.name + " "
				end
				puts ") \n\n"
				
				for i in 1..node.children.length
					for child in node.children
						spaces = spaces - ((node.children.length / 2) * 8) + (i*i*2)
						small_loop(child, spaces)
					end
				end
			end
		
		end
		
		small_loop(@root, spaces)
=end
	end
	
	def total_nodes
		@@total_nodes
	end
	
end