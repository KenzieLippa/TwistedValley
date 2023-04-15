extends Resource
class_name DnDInventory

#refrence to data we are dragging around so if we accidentally drag outside
#it isnt destroyed
var drag_data = null
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
	items[target_item_index] = item
	items[item_index] = targetItem
	emit_signal("items_changed", [item_index, target_item_index])
	
func remove_item(item_index):
	var previous_item = items[item_index]
	items[item_index] = null
	#has to be an array because of the type even tho its only one
	emit_signal("items_changed", [item_index])
	return previous_item #just in case we wanna use the item for something else
	
	#make items unique so they are not sharing resources
func make_items_unique():
	var unique_items = []
	for item in items:
		#account for the null case
		if item is Item2:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	items = unique_items
	
