extends Node2D

class_name Projectile #still have projectile class
#will need access to th async turn pool
var asyncTurnPool : AsyncTurnPool = RefrenceStash.asyncTurnPool

export(float) var travel_duration := 0.5

signal contact
signal collision_animation_finished

func move_to(target : BattleUnit, trans : int = Tween.TRANS_LINEAR, easing: int = Tween.EASE_IN) -> void:
	z_index = 25 #makes sure its in front of all units when created
	asyncTurnPool.add(self)
	#create a tween, want to ease in
	var tween := create_tween().set_trans(trans).set_ease(easing)
	var target_position := Vector2(target.global_position.x, global_position.y) #keep our current y value but use the targets x
	tween.tween_property(self, "global_position", target_position, travel_duration).from_current() #from cuttrent location
	#yield on completed
	yield(tween, "finished")
	#we have connected
	emit_signal("contact")
	#remove self from turn pool
	_animate_collision()
	#yield on signal
	yield(self, "collision_animation_finished") #handles what ever collision we have on the projectile
	asyncTurnPool.remove(self)
	queue_free() #destroy fireball
	
#extend and update in child classes, thats why its underscored
func _animate_collision() -> void:
	yield(get_tree(), "idle_frame") #exemption from the rule
	#in some cases is ok
