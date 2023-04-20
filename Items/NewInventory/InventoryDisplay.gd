extends GridContainer

#get access to th inventory resource
var inventory = preload("res://Items/NewInventory/Items/Inventory.tres")

func _ready():
	inventory.connect("items_changed", self, "_on_items_changed")
	inventory.make_items_unique()
	#load into singleton so theres always a refrence to it because then it wont delete
	#if there is no refrence then it will delete
	#on startup update the inventory
	update_inventory_display()
	

func update_inventory_display():
	#loop through entire inventory
	for item_index in inventory.items.size():
		#for each item in the inventory update the inventory display
		update_inventory_slot_display(item_index)

func update_inventory_slot_display(item_index):
	#updates specific slot display
	#gets the slot display that coresponds to the item in the inventory
	var inventorySlotDisplay = get_child(item_index)
	#gets the inventory item index we passed in
	var item = inventory.items[item_index]
	#function we created to properly show the item
	inventorySlotDisplay.display_item(item)

func _on_items_changed(indexes):
	#when we connect the signal then we can see that the index has been updated
	for item_index in indexes:
		update_inventory_slot_display(item_index)
		
func _unhandled_input(event):
	#input event that is unhandled, nothing has happened with it
	#dont want this to run if we actually drop this into the slot
	#will count tht as handeling the input
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary:
			#if you drop it it puts it back
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
