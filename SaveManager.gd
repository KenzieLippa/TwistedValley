extends Node

const TEST_PATH := "res://save.json"
#stores in the users directory
const SAVE_PATH := "user://save.json"

var file := File.new()


func save_game() -> void:
	#if cannot write the file then return
	if file.open(TEST_PATH, File.WRITE) != OK : return
	#get access to the players stats
	var stats : PlayerClassStats = RefrenceStash.elizabethStats
	var inventory : Inventory = RefrenceStash.inventory
	#remeber the players position
	var world_data : Dictionary = WorldStash.data
	#players global position is saved in the level swapper
	var player_global_position : Vector2 = RefrenceStash.player.global_position
	var save_data : Dictionary = {
		#store save data as a json
		#can use resources as save data
		#safer to do it as a json tho
		#first thing to save is current scene
		"current_scene" : get_tree().current_scene.filename,
		"player" : {
			"x" : player_global_position.x,
			"y" : player_global_position.y,
		},
		"stats" : {
			"level" : stats.level,
			"health" : stats.health,
			"experience" : stats.experience,
		},
		#an empty array, will have to fill after but we dnt know what to fill with
		"inventory" : [],
		"world_data" : world_data,
	}
	for item in inventory.items:
		#loop through all item in inventory
		save_data.inventory.append({
			#can pass dic as an argument
			#reload item when we load up the game
			"resource_path" : item.resource_path,
			"amount" : item.amount,
		})
	#now convert to a string tht can be stored in a json file
	var data_string := JSON.print(save_data) #creates string in json format
	print(data_string)
	#store in file
	file.store_string(data_string)
	file.close()

func load_game() -> void:
	#check to see if the file exists but will now be reading instead
	if file.open(TEST_PATH, File.READ) != OK: return 
	#get the data from the file as a string
	var data_string := file.get_as_text()
	#can close the file after getting th text
	file.close()
	
	#loading the data as a dictionary using JSON.parse to convert to a dict
	var load_data : Dictionary = JSON.parse(data_string).result
	#update the world stash data, both are dictionaries
	WorldStash.data = load_data.world_data
	
	#get access to the stats from the refrence stash
	var stats : PlayerClassStats = RefrenceStash.elizabethStats
	stats.level = load_data.stats.level
	stats.health = load_data.stats.health
	stats.experience = load_data.stats.experience #stats and experience are both keys
	
	#get access to the inventory
	var inventory : Inventory = RefrenceStash.inventory
	#clear and load in new items (no duplication)
	inventory.items.clear()
	for item_data in load_data.inventory:
		#loops through all the dictionarys in inventory, has resource path and amount
		var item : Item = load(item_data.resource_path) #loads the item back in
		#using the add item func
		inventory.add_item(item, item_data.amount)
		#item.amount = item_data.amount
		
	#do we need to recreate the player or not?
	#may be loading from the menu, will need to create a new player
	#if you load into the meadow there is no player
	if not RefrenceStash.player is KinematicBody2D:
		var player = load("res://World/OverworldPlayer.tscn").instance()
		#set level swapper 
		LevelSwapper.player = player
		RefrenceStash.player = player
		#makes sure tht there is a player, then we re-get access to it
	var player = RefrenceStash.player
	player.last_door_connection = -1 #dont snap to the door entrance when we go into the next scene
	yield(Transition.fade_to_color(Color.black), "completed") #hides the jitter
	LevelSwapper.level_swap(player, load_data.current_scene) #load in the current scene to the level swapper
	player.global_position = Vector2(load_data.player.x, load_data.player.y)
	Transition.fade_from_color(Color.black)
