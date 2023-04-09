extends Resource

class_name ClassStats

export(String) var name
export(int) var max_health setget set_max_health
export(int) var attack
export(int) var defense
#export(int) var speed
#export(int) var critical tho we might put this in th action instead

export(Array, Resource) var battle_actions
export(PackedScene) var battle_animations #better place in th class then in the battle unit
export(Script) var ai : Script = null

var level := 1
var health := 1 setget set_health

signal health_changed
signal no_health
signal max_health_changed
signal level_changed

func set_health(value : int) -> void:
	#clamp prevents health from going below or above a thing
	health = clamp(value, 0, max_health)
	emit_signal("health_changed")
	if health == 0: emit_signal("no_health")
	
func set_max_health(value : int)-> void:
	max_health = value
	health = max_health
	emit_signal("max_health_changed")

