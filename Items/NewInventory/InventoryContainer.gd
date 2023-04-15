extends ColorRect

#this is done to prevent the shit from escaping and getting deleted if you miss the slot
#access to the inventory
var inventory = preload("res://Items/NewInventory/Items/Inventory.tres")
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	#set back to previous location
	inventory.set_item(data.item_index, data.item)
