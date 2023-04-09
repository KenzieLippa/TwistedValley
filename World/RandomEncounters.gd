extends Sprite

export(Array, Resource) var encounters := []
#can easily set which encounters are possible inside the room

func _ready() -> void:
	#isnt called again because we arent re-instancing the town
	randomize() #randomize the seed so its different each time
	RefrenceStash.random_encounters = encounters
	hide() #want to hide this so we cant see it


func _exit_tree() -> void:
	#when we blow up the scene then it sets the reference stash to be empty
	RefrenceStash.random_encounters = [] #set back to null when we exit the room
	request_ready() #next time the node enters th scene tree again then re-request the ready func
#sets encounters back to whats set after reloaded
