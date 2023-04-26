extends Node

enum Seasons {SPRING, SUMMER, FALL, WINTER} 

#possibly add an enum for direction we will see

#might not currently have a reaping tool tho we will see, can always use the axe animation
enum ItemType{
	Seed,
	Commodity,
	WateringCan,
	HoeingTool,
	ChoppingTool,
	PickAxe,
	ReapingTool,
	CollectingTool,
	ReapableScenary,
	Furniture,
	none,
	count
}

#inventory locations
enum InventoryLocation{
	player, 
	#can use chests later maybe
	chest,
	count
}
