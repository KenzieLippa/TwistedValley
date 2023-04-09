extends Resource

class_name Inventory

export(Array, Resource) var items : Array = []

signal item_added(item_index, item)
signal item_changed(item_index, item)
signal item_removed(item_index)


func add_item(item: Item, amount : int = 1) -> void:
	#deault add item is one but u can add more
	#see if already in there other wise add a new one
	var item_index = items.find(item) #seems godot has a lot of built in functions you can use
	if item_index == -1:
		#item not found in the array
		items.append(item) #add to th list
		item.amount = amount #set th amount to what ever is next
		#should be propper index because adding to th end
		emit_signal("item_added", items.size()-1, item)
	else:
		#we did find the item and we want to update it by th smount we are adding
		items[item_index].amount += amount
		emit_signal("item_changed", item_index, item)
		
func remove_item(item : Item, amount : int = 1) -> Item:
	var item_index = items.find(item)
	if item_index == -1: return null
	
	item.amount -= amount
	#dont need to remove it if its just changed 
	emit_signal("item_changed", item_index, item)
	if item.amount <=0:
		items.erase(item)#built in function to remove from list
		emit_signal("item_removed", item_index) #emit the signal saying items been removed
	#returns the item either removed or modified
	return item
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
