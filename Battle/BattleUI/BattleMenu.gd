extends FocusMenu
class_name BattleMenu
const ANIMATION_DURATION = 0.4
const ANIMATION_DISTANCE = Vector2(0,36)
onready var action_button = $"%ActionButton"
onready var item_button = $"%ItemButton"
onready var run_button = $"%RunButton"

enum{
	ACTION,
	ITEM,
	RUN
}

#func grab_action_focus() -> void:
#	#grab focus 
#	action_button.grab_focus() # using the keys to navigate teh stuff
#
func show_menu() -> void:
	show()
	var tween := create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	#subtract 36, will tween 36 pixels above where we are, thats what as relative
	tween.tween_property(
		self, 
		"rect_global_position", 
		-ANIMATION_DISTANCE, 
		ANIMATION_DURATION
		).as_relative().from_current() #because is a control we have to do a control
	yield(tween, "finished")
	
func hide_menu()-> void:
	var tween := create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	#subtract 36, will tween 36 pixels above where we are, thats what as relative
	tween.tween_property(
		self, 
		"rect_global_position", 
		ANIMATION_DISTANCE, 
		ANIMATION_DURATION
		).as_relative().from_current()
	yield(tween, "finished")
	hide()
	
signal menu_option_selected(option)


func _on_ActionButton_button_down():
	emit_signal("menu_option_selected", ACTION)
	#print("Action")

func _on_ItemButton_button_down():
	emit_signal("menu_option_selected", ITEM)
	#print("Item")


func _on_RunButton_button_down():
	emit_signal("menu_option_selected", RUN)
	#print("Run")
