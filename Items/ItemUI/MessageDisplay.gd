extends CenterContainer

onready var label = $"%Label"
#will process while paused
func _ready() -> void:
	#connect to the events system
	Events.connect("request_show_message", self, "show_message")
	#show_message("Hi this is a new message")

#so it doesnt capture the input and then makes it so we can no longer use it elsewhere
func _unhandled_input(event : InputEvent) -> void:
	if not visible : return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		get_tree().paused = false
		get_tree().set_input_as_handled() #dont let this input go to other things
		hide()
func show_message(message : String) -> void:
	show() # show th message
	#pause so th player cant move around
	get_tree().paused = true
	label.text = message
