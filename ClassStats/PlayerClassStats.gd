extends ClassStats

class_name PlayerClassStats

const MAX_EXPERIENCE := 100

export(Resource) var inventory : Resource

var experience := 0 setget set_experience



func set_experience(value : int) -> void:
	experience = value
	while experience >= MAX_EXPERIENCE:
		experience = experience - MAX_EXPERIENCE #get to have what ever is left over
		level += 1 #if over the max experience then add to the level 
		#we do this to make sure we are leveling up the right number of times
		emit_signal("level_changed")
