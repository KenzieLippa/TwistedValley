extends Resource
class_name ItemDetails

export(int) var item_code = 0
export(Enums.ItemType) var item_type = Enums.ItemType.none
export(String) var item_name = ""
export(Texture) var item_sprite
export(String, MULTILINE) var item_description= ""
#should be a short but there are no shorts so hopefully this works
export(int) var item_use_grid_radius = 0 #using the grid
export(float) var item_use_radis = 0 #using the radius
export(bool) var starting_item = false
export(bool) var can_be_picked_up = false
export(bool) var can_be_dropped = false#for tools, can it be picked up or not
export(bool) var can_be_eaten = false#for eating
export(bool) var can_be_carried =false#can it be carried over the head when clicked on
