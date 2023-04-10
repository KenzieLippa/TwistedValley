extends Interactable

#refrence the inventory
var inventory :Inventory = RefrenceStash.inventory
export(Resource) var item : Resource setget set_item

onready var sprite := $Sprite
onready var pickup_sound = $OutliveParent/PickupSound


#get unique id string for item picked up
#have to do in onready for th global
onready var id := WorldStash.get_id(self)

func _ready():
	#passing the world stashs stash our id argument then our key and then value
#	WorldStash.stash(id, "freed", true)
#	print(WorldStash.data)
	#free ourselves if we are not supposed to be there
	if WorldStash.retrieve(id, "freed"):
		queue_free() #if we are not supposed to be there then kill us
	


func set_item(value : Item)->void:
	item = value
	#waits for the call
	call_deferred("set_sprite_texture", item)
	#if sprite: sprite.texture = item.overworld_texture

func set_sprite_texture(item :Item)->void:
	#freaks out when we come back into the room
	#make sure sprite exists before we set it
	if not sprite: return #trying to set a texture on a sprite that might not exist 
	sprite.texture = item.overworld_sprite
	

func _run_interaction() -> void:
	inventory.add_item(item) #adds the item to the inventory
	#if we rush to pickup item and is not on outlive parent then it will get cut off when destroyed
	pickup_sound.play()
	#print(inventory.items)
	Events.emit_signal("request_show_message", "You found a "+ str(item.name) + " \n"+item.description)
	#store that the item has been freed
	WorldStash.stash(id, "freed", true) #telling it that we have freed th item
	queue_free()
