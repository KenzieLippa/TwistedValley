extends ParentButton

class_name ResourceButton

var resource : Resource 

signal resource_selected(resource) #when selected we will send the resource out with th signal




func _on_ResourceButton_button_down():
	emit_signal("resource_selected", resource)
