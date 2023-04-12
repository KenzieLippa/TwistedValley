extends Animal

#onready var cow_animation_player = $AnimationPlayer
onready var timer = $Timer


func _run_interaction():
	#print("MOOOOO")
	#Events.emit_signal("request_show_message", "I am a magical cow \n I say moo")
	#plays the love animation
	animation_player.play("Love")
	#can make more efficient later but rn just yield on timer
	timer.start(1.0)
	yield(timer, "timeout")
	#when its done want to play idle
	animation_player.play("Idle") #will need ability to yield on animations
	
	#will want to be able to feed the cow
	
	#will want the cow to have health
	
	
	
	
