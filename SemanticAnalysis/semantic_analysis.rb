#!/usr/bin/env ruby


###################################################
# This is the tokenizer of the 03-K64 Compiler.
# Crafted for Alan's 'Design Compilers' class,
# lovingly coded in Ruby magic, and narrated by
# her captain.
#
#
# Author: Kevin Pietrow
# Version: The shinier one
# 
# Note: Instructions for running the best compiler
# 		in the Verse can be found in the README
#


def semantic_analysis

	$ast = AbstractSyntaxTree.new
	$st = SymbolTable.new
	$index = 0
	
	
	
	$ast = convert_cst
	
end

