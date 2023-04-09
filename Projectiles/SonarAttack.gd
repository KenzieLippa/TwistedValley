extends Projectile

onready var animation_player = $AnimationPlayer
onready var sonar_impact_sound = $SonarImpactSound

#played at th end when we collide
func _animate_collision() ->void:
	#play th sonar impact
	sonar_impact_sound.play()
	animation_player.play("End")
	yield(animation_player, "animation_finished")
	emit_signal("collision_animation_finished")

#will be called every time animation is finished
func _on_AnimationPlayer_animation_finished(animation_name : String)->void:
	if animation_name != "Start" : return
	#otherwise play the repeat
	animation_player.play("Repeat")
	
