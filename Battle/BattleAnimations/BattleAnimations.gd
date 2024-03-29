extends Sprite
class_name BattleAnimations

#attach to both and will work cause they both in same place in scene tree and named the same

onready var animation_player := $AnimationPlayer
onready var emission_point := $EmissionPoint

signal animation_finished #creating our own class here

#should have put this all in a parent class, perhaps wld be smart to do in future
func _ready() -> void:
	#connecting to our own self in the emmit and then sending th signal out ourselves too
	animation_player.connect("animation_finished", self, "_on_animation_finished")
	#on animation finished then it passes an argument out
	#trying to emit signal based on the animation finished
	#so need a custom func
	
func get_emission_position() -> Vector2:
	return emission_point.global_position #return our global position of the emission point
	#need to add this to the werewolf
func get_current_animation_length() -> float:
	#if you set th playback speed then you have to account for it when u get th length
	return animation_player.current_animation_length / animation_player.playback_speed
#how long apparoach animations ect to see how long we shld move along the ground for

func play(animation_name : String) -> void:
	#if we try to play an animation tht doesnt exist then error
	assert(animation_player.has_animation(animation_name)) #tried to play animaiton we dnt have
	animation_player.play(animation_name)

func _on_animation_finished(animation_name : String) -> void:
	emit_signal("animation_finished") #emits the signal so you dont have to worry about emiting and looking for th wrong ones
	
