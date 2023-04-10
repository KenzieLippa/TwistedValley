extends PanelContainer

var stats = RefrenceStash.playerStats
onready var level := $"%Level"
onready var health_bar := $"%HealthBar"
onready var experience_bar := $"%ExperienceBar"

signal animation_finished #tell when an animation is finished if we play one

#is not called in the main scene, is only called here

func _ready():
	#make sure it doesnt keep trying to update stats
	if not stats.is_connected("health_changed", self, "_on_health_changed"):
		#only connects the first time
		stats.connect("health_changed", self, "_on_health_changed")
	 #connect th signal
	update_stats()
	
#func _input(event):
#	#using the animation to show that the player healed
#	if event.is_action_pressed("ui_down"):
#		stats.health -=2
#	elif event.is_action_pressed("ui_up"):
#		stats.health +=2

func update_stats() ->void:
	#updates all UI elements so they match the actual stats
	level.text = "Level : " + str(stats.level)
	health_bar.set_bar(stats.health, stats.max_health)
	experience_bar.set_bar(stats.experience, stats.MAX_EXPERIENCE)
	
func _on_health_changed():
	#doesnt run outside the scene tree which is good
	#isnt updsting health
	health_bar.animate_bar(stats.health, stats.max_health)
	yield(health_bar, "animation_finished") #make sure the animation is finished
	#then emit the signal
	emit_signal("animation_finished")
	
#updates elizabeths stats when we re-enter th tree
func _exit_tree() -> void:
	#when we come back from a battle needs to request ready
	request_ready()
	#will call ready func again when exiting
