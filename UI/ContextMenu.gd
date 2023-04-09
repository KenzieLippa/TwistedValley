extends FocusMenu
class_name ContextMenu

signal option_selected(option)
enum{
	USE,
	INFO
}
#dont forget to log focus nodes

func _on_UseButton_button_down():
	emit_signal("option_selected", USE)


func _on_InfoButton_button_down():
	emit_signal("option_selected", INFO)
