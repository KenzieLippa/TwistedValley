extends CenterContainer

onready var item_texture_rect = $ItemTextureRect
#need access to inventory here too
var inventory = preload("res://Items/NewInventory/Items/Inventory.tres")


func display_item(item):
	if item is Item2:
		#make sure is not null
		item_texture_rect.texture = item.texture
	else:
		item_texture_rect.texture = load("res://Items/NewInventory/Items/EmptyInventorySlot.png")
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
		set_drag_preview(dragPreview)
	
func can_drop_data(_position, data):
	#can it accept drop data?
	#will return true if the data is a dictionary and the data has the key item
	return data is Dictionary and data.has("item")
	
	
func drop_data(_position, data):
	#drops into the control node
	#var my_item_index
	pass
