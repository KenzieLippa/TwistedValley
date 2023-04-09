extends Projectile

onready var animated_sprite := $AnimatedSprite
onready var flame := $Flame
onready var explosion := $Explosion
onready var fire_impact_sound := $FireImpactSound



func _animate_collision() -> void:
	#play the impact sound
	fire_impact_sound.play()
	#extend the function from the other one
	animated_sprite.hide()
	flame.hide() # hide both the sprite and the flame when animating explosion
	explosion.emitting = true #turn the emission on 
	#must also yield 
	#create nice explosion effect for hitting hte enemy
	while explosion.emitting == true:
		yield(get_tree(), "idle_frame") # wait a frame while emitting
	emit_signal("collision_animation_finished") # can now do this cause its over
