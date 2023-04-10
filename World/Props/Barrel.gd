extends Interactable

#get access to the inventory
var inventory : Inventory = RefrenceStash.inventory
export(Resource) var item : Resource

onready var id := WorldStash.get_id(self)
#gets our id

func _ready():
	#if our stashed item is null then no item
	if WorldStash.retrieve(id, "item") == "none":
		item = null #if we have no item then set to null

func _run_interaction()->void:
	if item is Item:
		inventory.add_item(item)
		Events.emit_signal("request_show_message", "You found a " + str(item.name))
		item = null
		WorldStash.stash(id, "item", "none") #store the item
	else:
		Events.emit_signal("request_show_message", "This is a barrel of shit... \nbest not put your nose to close")
	
	#layer is where it is and mask is what its looking to
