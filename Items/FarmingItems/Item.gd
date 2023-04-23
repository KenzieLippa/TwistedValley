extends Node
class_name FarmItem

export(int) var item_code
export(Resource) var item
#not sure if this is right or not
#get access to the onready var of the sprite
onready var sprite = $Sprite
#might need a spot to put the resource or link to the list, we shall see

#var ItemCode setget set_itemCode

#func set_itemCode(value):
#	_item_code = value
#
#func get_itemCode():
#	return _item_code
	
func _ready():
	#check current item code and if not 0 then initialize the item
	if item_code !=0:
		init_item(item_code)
		
func init_item(item_code : int):
	pass
	

#when called and created
#func _init():
	#game object will have a child that holds a sprite renderer
	#hmmm idk if we can get the component or not

