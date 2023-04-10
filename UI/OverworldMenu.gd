extends FocusMenu

class_name OverworldMenu

enum {STATS, ITEMS, SAVE, LOAD, QUIT}

signal option_selected(option)

#func _ready() -> void:
#	get_tree().paused = true # pauses the rest of game while active
#	grab_focus() #grabs focus sso u can navigate
#	#need to tell it what the focus nodes are

func _on_StatsButton_button_down():
	emit_signal("option_selected", STATS)


func _on_ItemsButton_button_down():
	emit_signal("option_selected", ITEMS)

func _on_SaveButton_button_down():
	emit_signal("option_selected", SAVE)
	
func _on_LoadButton_button_down():
	emit_signal("option_selected", LOAD)


func _on_QuitButton_button_down():
	emit_signal("option_selected", QUIT)
