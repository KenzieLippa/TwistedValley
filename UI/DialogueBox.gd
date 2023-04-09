extends TextureRect

#handles the typer animation for this dialogue box
const CHARACTER_DISPLAY_DURATION = 0.04
var typer : SceneTreeTween
var is_typing : bool = false
var pitch := 1.0

onready var textbox = $"%TextBox"
onready var portrait = $"%Portrait"
onready var portrait_name = $"%PortraitName"
onready var voice = $Voice


#signal dialogue_finished # know when dialogue finished typing

func _ready():
	Events.connect("request_show_dialogue", self, "type_dialog")
	#type_dialog("Hi how are you today you fiend!", load("res://Characters/ElizabethCharacter.tres"))

func _unhandled_input(event : InputEvent) -> void:
	if not visible: return #dont wanna take input if not shown
	if not event.is_action_pressed("ui_accept"): return #if not the accept key then return
	
	if is_typing:
		is_typing = false
		if typer is SceneTreeTween: typer.kill()
		#set the text to be full visible
		textbox.percent_visible = 1.0
	else:
		#done typing
		hide()
		#make sure the input doesnt try to handle again
		get_tree().set_input_as_handled()
		#unpause
		get_tree().paused = false
		Events.emit_signal("dialogue_finished")

func type_dialog(bbcode : String, character : Character) -> void:
	is_typing = true
	portrait_name.text = character.name
	portrait.texture = character.portrait #sets the portrait to the character
	pitch = character.voice_pitch
	#dont forget to set to process in the pause mode
	get_tree().paused = true #pause the game
	show() #the textbox
	textbox.bbcode_text = bbcode
	#character content not available till th next frame
	#yield(get_tree(), "idle_frame") #only way to get accurate character count
	#cant just get in bb string bc th char in th string are not all char used and displayed, some are code
	#must wait for get total char count to be accurate
	#can get now tht we have waited
	#will not include the markup text and code that is hidden
	var total_characters : int = textbox.text.length() #can use even tho we using bbcode
	#when setting bb value it doesnt count for text
	var duration : float = total_characters * CHARACTER_DISPLAY_DURATION #duration for each char
	#now need to tween through each character
	typer = create_tween()
	#tween method, get more control, play more text
	typer.tween_method(self, "set_visible_characters", 0, total_characters, duration)
	yield(typer, "finished") #make sure this completes
	is_typing = false
	
	
func set_visible_characters(index : int) -> void:
	#for sound effects probably
	var is_new_character : bool = index > textbox.visible_characters
	textbox.visible_characters = index
	#if a new character and not done with th text
	if is_new_character and index < textbox.get_total_character_count():
		#gets th current char
		var character : String = textbox.text.substr(textbox.visible_characters, 1)
		#variate the pitch so it douesnt sound liks shit
		voice.pitch_scale = rand_range(pitch -0.1, pitch + 0.1)
		voice.play()
	#when we get to it in the course replace .get_total_char_count() with text.length()
