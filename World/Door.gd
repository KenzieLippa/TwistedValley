extends Area2D
class_name Door

#exports a spot for the string to go in which has a string file that will take you to new area
export(String, FILE, "*.tscn") var new_area  
#know which scene we going to
#know which door in next scene we going to 
export(int, 32) var connection
#dnt forget to set collision layers
#can click and make unique on the shape to make sure they arent using shared resources
export(bool) var door_sound_effect := false

onready var drop_point = $DropPoint
