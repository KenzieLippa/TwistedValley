extends Node

onready var current_scene = get_tree().current_scene
#wont work if attached to town scene
#grabs the current scene created in
#could attach to the root of th scene then it wld work
#but you want to destroy it so...

func _ready():
	#when parent is exiting we will reparent ourself to the current scene
	get_parent().connect("tree_exiting", self, "reparent")
	
func reparent() -> void:
	#if not a valid instance then return
	if not is_instance_valid(current_scene): return
	var parent := get_parent()
	parent.remove_child(self) #remove ourselves as a child
	current_scene.call_deferred("add_child", self)
	#will live forever in that scene

