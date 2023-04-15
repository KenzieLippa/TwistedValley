extends CenterContainer

onready var item_texture_rect = $ItemTextureRect
onready var item_amount_label = $ItemTextureRect/ItemAmountLabel
#need access to inventory here too
var inventory = preload("res://Items/NewInventory/Items/Inventory.tres")


func display_item(item):
	if item is Item2:
		#make sure is not null
		item_texture_rect.texture = item.texture
		item_amount_label.text = str(item.amount)
		
	else:
		item_texture_rect.texture = load("res://Items/NewInventory/Items/EmptyInventorySlot.png")
		item_amount_label.text = ""#if no item
#func _input(event):
#	if event is InputEventMouseButton:
#		print("Mouse clicked successfully read.")
#built into godot 
func get_drag_data(_position):
	print("being called")
	var item_index = get_index()
	#removing from th inventory storing in here
	var item = inventory.remove_item(item_index)
	if item is Item2:
		var data = {}
		#new key in dict and store the item
		data.item = item
		data.item_index = item_index
		#remeber th index the item was in
		#create a texture rect so we can see whats being dragged
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		#set the drag preview to be the drag preview
		#chat gpt is useless
#		dragPreview.rect_min_size = dragPreview.texture.get_size()
##		dragPreview.anchor_bottom = 0.5
##		#half the min size
#		#dragPreview.rect_position +=  Vector2(1,1)
#		var c = Control.new()
#		c.add_child(dragPreview)
#		dragPreview.rect_position = 0.5*dragPreview.rect_size
		set_drag_preview(dragPreview)
		inventory.drag_data = data
		return data
	
func can_drop_data(_position, data):
	#can it accept drop data?
	#will return true if the data is a dictionary and the data has the key item
	return data is Dictionary and data.has("item")
	
	
func drop_data(_position, data):
	#drops into the control node
	#var my_item_index
	var my_item_index = get_index()

	var my_item = inventory.items[my_item_index]
	
	#check to see if item is actually an item
	if my_item is Item2 and my_item.name == data.item.name:
		#compare this with th item in th drop data
		#add this to the current amount
		my_item.amount += data.item.amount
		#we have changed the item so emit the signal
		inventory.emit_signal("items_changed", [my_item_index])
	else:
		#if not the same item

	#swap items with the data
	#where the item was before, what ever was there before will be switched
	#with the old stuff
		inventory.swap_item(my_item_index, data.item_index)
	#my item index is where we got it from and then data.item
	#
		inventory.set_item(my_item_index, data.item)
	inventory.drag_data = null #sets the drag data back to null after being dropped
