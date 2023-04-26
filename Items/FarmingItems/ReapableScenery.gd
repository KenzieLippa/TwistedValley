extends FarmItem


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var collision_shape_2d = $CollisionShape2D
#onready var position_2d = $Sprite/Position2D

const PAUSE = 0.1

#dont try to start another animation
var is_animating : bool = false
var rot_left = 15
var rot_right = -15


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ReapableScenery_area_entered(body):
	if is_animating == false:
		#possibly put in a check to see which first
		if body.global_position.x < self.global_position.x:
			rotate_left()
		else:
			rotate_right()
		
		
func rotate_left():
	var left_rotate = rot_left
	var start = sprite.rotation_degrees
	var tween = create_tween() #can set special properties later
	tween.tween_property(sprite, "rotation_degrees", left_rotate, PAUSE)
	#yield(tween, "finished")
	tween.tween_property(sprite, "rotation_degrees", start, PAUSE)
	#yield(tween, "finished")

func rotate_right():
	var right_rotate = rot_right
	var start = sprite.rotation_degrees
	var tween = create_tween()
	tween.tween_property(sprite, "rotation_degrees", right_rotate, PAUSE)
	tween.tween_property(sprite, "rotation_degrees", start, PAUSE)
