extends NPC

const ELIZABETH_CHARACTER : Character = preload("res://Characters/ElizabethCharacter.tres")
const APPLE_ITEM : Item = preload("res://Items/AppleItem.tres")

var inventory :Inventory = RefrenceStash.inventory
var has_apple := false

onready var id := WorldStash.get_id(self)

func _ready():
	if WorldStash.retrieve(id, "has_apple") == true:
		has_apple = true #set th apple to be in there if its supposed to be
	#cant set boolean to null, do we have it then we can do it
func _run_interaction() -> void:
	if not has_apple:
		#he does not have the apple but elizabeth does
		
		Events.emit_signal("request_show_dialogue", "AHHHHHH! I have a headache", character)
		yield(Events, "dialogue_finished")
		Events.emit_signal("request_show_dialogue", "Do you have a cure?", character)
		yield(Events, "dialogue_finished")
		var apple = inventory.remove_item(APPLE_ITEM)
		#if no item
		if apple is Item:
			Events.emit_signal("request_show_dialogue", "Here, maybe this apple will cure you!", ELIZABETH_CHARACTER)
			yield(Events, "dialogue_finished")
			Events.emit_signal("request_show_dialogue", "It's this one", ELIZABETH_CHARACTER)
			yield(Events, "dialogue_finished")
			#set that he does actually have an apple
			has_apple = true
			WorldStash.stash(id, "has_apple", true)
		else:
			Events.emit_signal("request_show_dialogue", "Hmm... I will look around for you.", ELIZABETH_CHARACTER)
			yield(Events, "dialogue_finished")
	if has_apple:
		#runs right after apple given
		Events.emit_signal("request_show_dialogue", "I feel much better now! Thank you so much!", character)
		yield(Events, "dialogue_finished")
		Events.emit_signal("request_show_dialogue", "You're welcome!", ELIZABETH_CHARACTER)
		yield(Events, "dialogue_finished")
