extends Node

var data : Dictionary = {} #set to an empty dictionary
# will need to put in all the objects that we can store info about
#then those will have their own dict with terms and such
#refrence these values later, will be carried accross all different scenes
#stash cause not saving or loading anything
#can probably use this for characters to, can set the characters to levels and then have dialogue based on th levels loaded in
#each dialogue line can have conditions and if those are met then the game will call in that dialogue, look at tht one video
#can also set this up visually in twine
func get_id(node : Node) ->String:
	var main : Node = get_tree().current_scene #get the current scene
	return (
		main.name 
		+"_"
		+ node.name 
		+"_"
		+ str(node.global_position)
	)
#need to use something unique
#use the name of the node, the name of the scene and then th position


func stash(id : String, key : String, value):
	#dont know what type value is gonna be
	data[id] = {} #creating an empty dictionary with our key id
	#contains list of nodes and then each node contains a dict with each of all our ids
	data[id][key] = value #has some kind of key and some kind of value
	
	#this is a visual representation of the dictionary struct
	#we are making
#	var data = {
#		#in test dict we have this node as a key and it has its own dict
#		#of properties
		#this is the id value we pass in and the value for tht is a dictionary
#		"Town_Player_(0,0)" : {
#			#key in town players dict and its value
#			#this is the key value we pass in the second parenthesis
			#so data[id][KEY] and then true is value
			#"happy" : true
#		}
#	}

#how will we retrieve
func retrieve(id :String, key: String):
	#returns something but we dont know what
	#if data doesnt have the id return nothing
	if not data.has(id): return null
	#if data doesnt have the key return nothing
	if not data[id].has(key): return null 
	#if it has both th id and th key then
	return data[id][key] #will return th value stored
