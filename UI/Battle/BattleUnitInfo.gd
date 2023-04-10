extends Control

#represent info about a class
var stats : ClassStats setget set_stats


onready var health_bar := $HealthBar
onready var level_label := $LevelLabel


func set_stats(value : ClassStats )->void:
	stats = value
	connect_stats()

func update_level() -> void:
	level_label.text = "Level : " + str(stats.level)
	
func connect_stats() -> void:
	if not stats is ClassStats: return #dont try to connect on something that is null
	stats.connect("health_changed", self, "_on_stats_health_changed")
	#is used by the enemy as well so we needed to put level changed in the parent so enemy 1 could have this signal too
	stats.connect("level_changed", self, "_on_stats_level_changed")
	#accurately represents our stats
	health_bar.set_bar(stats.health, stats.max_health)
	update_level()
	
func _on_stats_health_changed()->void :
	#animate the health bar
	health_bar.animate_bar(stats.health, stats.max_health)
	
func _on_stats_level_changed() -> void:
	update_level()
