extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#can now connect
	Events.connect("request_update_camera_limits", self, "_on_request_update_camera_limits")
	
func _on_request_update_camera_limits(limits : Rect2) -> void:
	limit_left = limits.position.x
	limit_right = limits.end.x
	limit_top = limits.position.y
	limit_bottom = limits.end.y
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
