extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#in case there are weird things with th limits
	yield(get_tree(),"idle_frame")
	var camera_limits := Rect2(rect_global_position, rect_size)
	#using own camera limits for it
	Events.emit_signal("request_update_camera_limits", camera_limits) #send out with signal
	hide() # so we dont see it


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
