extends PanelContainer

onready var rich_text_label = $"%RichTextLabel"

var text := "" setget set_text #want this to be a property

func set_text(value : String) -> void:
	text = value
	rich_text_label.text = text
