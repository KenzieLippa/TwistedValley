extends Node

var player : KinematicBody2D


func stash_player(player_to_stash : KinematicBody2D) -> void:
	player = player_to_stash
	#finds the parent and removes the child from it and makes this an orphan node
	player.get_parent().remove_child(player)

func level_swap(player_to_stash : KinematicBody2D, new_level_string : String) -> void:
	stash_player(player_to_stash)
	get_tree().change_scene(new_level_string)
	drop_player()
	
func drop_player() -> void:
	#have to wait a frame to make sure the level is setup
	yield(get_tree(), "idle_frame") #exception to never yield up the tree
	var parent := get_tree().current_scene
	#add player as a child
	parent.add_child(player)
	player.owner = parent #set the new owner to be the new parent
	#update the players position but we need the doors first
	#drops the player in the new level
	#need to use the drop point
	for door in get_tree().get_nodes_in_group("Doors"): #get all the doors
	#compare the connection
		#looping through doors and compare the connections
		if door.connection != player.last_door_connection: continue
		#continue to the next door
		player.global_position = door.drop_point.global_position
