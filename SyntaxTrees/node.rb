#!/usr/bin/env ruby


class UnknownNodeError < StandardError
	def initialize (node)
		puts "ERROR: Found out-of-place node: #{node.name}."
		exit
	end
end



# Class for nodes on the syntax trees
class Node
	attr_reader :total_id, :id, :token, :name, :type
	attr_accessor :parent, :children
	
	@@total_id = 0
	@id = nil
	@type = nil
	@name = nil
	@token = nil
	@children = []
	@parent = nil
	
	def initialize (type, name = nil, token = nil, parent = nil)
		@@total_id = @@total_id + 1
		@id = @@total_id
		@type = type
		@name = name
		@token = token
		@parent = parent
		@children = []
	end
	
	# add child, set child's parent
	def add_child (type, name, token = nil)
		new_node = Node.new(type, name, token, self)
		@children.push(new_node)
		return new_node
	end
	
	# add parent
	def add_parent (parent)
		@parent = parent
	end
	
end