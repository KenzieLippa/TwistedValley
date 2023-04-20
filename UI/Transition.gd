extends CanvasLayer

onready var color_rect = $ColorRect

#we add the current color so that we dont accidentally fade from what we last picked
func fade_to_color(color: Color, duration : float = 0.25) -> void:
	#create a tween
	var tween := create_tween()
	var color_no_alpha = Color(color.r, color.g, color.b,0)
	tween.tween_property(color_rect, "color", color, duration).from(color_no_alpha)
	yield(tween, "finished") #wait till th tween is done
	
func fade_from_color(color : Color, duration : float = 0.25) -> void:
	var tween := create_tween()
	var color_no_alpha = Color(color.r, color.g, color.b,0)
	#tween from current
	tween.tween_property(color_rect, "color", color_no_alpha, duration).from(color)
	yield(tween, "finished") #wait till th tween is done
#can have it pause game during transition but rn not worrying about it


func set_color(color : Color) ->void:
	color_rect.color = color
#orriginally was layer 100
