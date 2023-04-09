extends ScrollList

#class_name ItemList is a native class

var inventory : Inventory = RefrenceStash.inventory
#loads
#specifically for inventory items
#WANT TO keep track of items and make sure items are properly added and removed
func _ready() ->void:
	fill(inventory.items) #fills item stuff
	#print(inventory.it)
	#will need to connect to diff signals in the inventory
	inventory.connect("item_added", self, "_on_item_added")
	inventory.connect("item_changed", self, "_on_item_changed")
	inventory.connect("item_removed", self, "_on_item_removed")
	
func fill(resource_list : Array) -> void:
	.fill(resource_list) #call the parents fill function
	#set what we can and cannot focus on 
	
	for button in button_container.get_children():
		update_item_button_text(button)
	
	
func update_item_button_text(button : ResourceButton) -> void:
	button.text = button.resource.name + " x" + str(button.resource.amount)#update the button to have the resource name displayed
	#need to update on each item in the list
	
	#now we need to make all these functions
func _on_item_added(item_index : int, item : Item) ->void:
	#adds to the button container
	var item_button : ResourceButton = add_resource_button() #comes from the scroll class
	item_button.resource = item #adding an item then we add a button for it
	update_item_button_text(item_button) #update the text using the item button we just made
	

func _on_item_changed(item_index :int, item : Item) -> void:
	#get the item index and access to it 
	#changing the item 
	var item_button :ResourceButton = button_container.get_child(item_index)
	item_button.resource = item
	update_item_button_text(item_button)
	
func _on_item_removed(item_index : int) ->void:
	var item_button : ResourceButton = button_container.get_child(item_index)
	#destroy the button
	item_button.queue_free()
	#will still be on the list but as null if not removed
	#focus menu has a list of focus nodes so we have to remove this from the button list in focus nodes
	focus_nodes.remove(item_index)
	

