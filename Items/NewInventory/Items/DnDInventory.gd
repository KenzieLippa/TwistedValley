extends Resource
class_name DnDInventory

#holding the collection of items
#sending signal with th array of changed items
signal items_changed(indexes)

export(Array, Resource) var items = [
	null, null, null, null, null, null, null, null, null
]

func set_item(item_index, item):
	#grab the item that might already be there
	var previous_item = items[item_index]
	items[item_index] = item
	#has to be an array because of the type even tho its only one
	emit_signal("items_changed", [item_index])
	return previous_item #just in case we wanna use the item for something else
	
func swap_item(item_index, target_item_index):
	var targetItem = items[target_item_index]
	var item = items[item_index]
	#swap them
	items[target_item_index] = items
	items[item_index] = targetItem
	emit_signal("items_changed", [item_index, target_item_index])
	
func remove_item(item_index):
	var previous_item = items[item_index]
	items[item_index] = null
	#has to be an array because of the type even tho its only one
	emit_signal("items_changed", [item_index])
	return previous_item #just in case we wanna use the item for something else
	
	
