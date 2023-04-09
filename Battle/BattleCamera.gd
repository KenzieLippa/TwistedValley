extends Camera2D
class_name BattleCamera

#create a single func for multiple positions
func focus_target(target_position : Vector2, target_zoom : Vector2, duration : float = 0.4) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	#var target_position = Vector2(target.global_position.x, global_position.y )
	tween.tween_property(self, "global_position", target_position, duration)
	#want to tween th zoom as well, does this in parallel
	tween.parallel().tween_property(self, "zoom", target_zoom, duration).from_current()
	yield(tween, "finished")
