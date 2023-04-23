extends Node

#making a dictionary? for all the item fields
var itemDetailsDictionary : Dictionary ={
	
}
export(Resource) var list
var itemList : Array

func _ready():
	
	for item in list.item_details:
		#print(item)
		itemList.append(item)
	create_item_details_dictionary()
	
#populates the item details dictionary from the items d
#populates correctly
func create_item_details_dictionary():
	#start from scratch
	itemDetailsDictionary.clear()
	for item in itemList:
		#populate dict based on values seen in there
		#put all details in the dict
		#print("this is running?")
		itemDetailsDictionary[item.item_code] = item

	#print(itemDetailsDictionary)
		
		
#get the item details from any item code
func get_item_details(item_code :int):
	var itemDetails
	#if the passed item code exsists then return it
	if itemDetailsDictionary[item_code] != null:
		#return whats in that slot of the dictionary
		itemDetails = itemDetailsDictionary[item_code]
	return itemDetails
