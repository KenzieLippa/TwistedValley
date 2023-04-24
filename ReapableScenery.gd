extends FarmItem


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var collision_shape_2d = $CollisionShape2D
#onready var position_2d = $Sprite/Position2D

onready var pause = $Pause

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


func _on_ReapableScenery_area_entered(area):
	if is_animating == false:
		#possibly put in a check to see which first
		rotate_left()
		
		
func rotate_left():
	var left_rotate = rot_left
	var right_rotate = rot_right + abs(rot_left)
	var tween = create_tween() #can set special properties later
	tween.tween_property(sprite, "rotation_degrees", left_rotate, 0.1)
	#yield(tween, "finished")
	tween.tween_property(sprite, "rotation_degrees", right_rotate, 0.1)
	#yield(tween, "finished")
