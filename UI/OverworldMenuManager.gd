extends MarginContainer
class_name OverworldMenuManager

#need access to inventory and stats
var stats : PlayerClassStats = RefrenceStash.elizabethStats
var inventory : Inventory = RefrenceStash.inventory


#need a ui stack
var uiStack := UIStack.new()

onready var overworld_menu := $"%OverworldMenu"
onready var elizabeth_stats := $"%ElizabethStats"
onready var item_list := $"%ItemList"
onready var context_menu := $"%ContextMenu"
onready var info_menu := $"%InfoMenu"
onready var heal_sound := $HealSound

onready var timer := $Timer

var item_resource : Item #for remebering what item we used

func _ready():
	#recreated ready function
	Events.connect("request_show_overworld_menu", self, "_on_request_show_overworld_menu")

func use_healing_item(item : HealingItem) -> void:
	set_process_unhandled_input(false) #dont want to be able to do anything else while we are doing this
	uiStack.pop()
	uiStack.pop() #remove both menus
	uiStack.push(elizabeth_stats) #this is the menu we wanna show
	inventory.remove_item(item)
	#play sound
	heal_sound.play()
	stats.health += item.heal_amount #add the heal amount to th health
	yield(elizabeth_stats, "animation_finished")
	#start a timer
	timer.start(0.25)
	#make sure its finished
	yield(timer, "timeout")
	uiStack.pop() #hide stats again
	uiStack.push(item_list) #return back to the item list
	set_process_unhandled_input(true)
#func _ready() -> void:
#	uiStack.push(overworld_menu) #temp for testing
#	#dnt forget to test things in steps
func _unhandled_input(event : InputEvent) -> void:
	#check if cancel
	if event.is_action_pressed("ui_cancel"):
		if not uiStack.empty():
			uiStack.pop() #if not empty then pop it
			#check if empty only after poping
			if uiStack.empty():
				#set input as handled so the function stops calling
				#input propegating to the player, still has unhandled input
				#close menu but then it re-opens
				get_tree().set_input_as_handled()
				#make sure its empty before cancelling out of the menu
				get_tree().paused = false
			
func _on_request_show_overworld_menu() -> void:
	uiStack.push(overworld_menu)
	#get the tree and pause
	get_tree().paused = true

#from overworld menu script if you are curious how this signal is written
func _on_OverworldMenu_option_selected(option : int) -> void:
	match option:
		OverworldMenu.STATS:
			#push onto the stack the stats of the character
			#reminder to go thru and change elizabeth to player in all places
			uiStack.push(elizabeth_stats)
		OverworldMenu.ITEMS:
			uiStack.push(item_list)
		OverworldMenu.SAVE:
			#set input as handled
			get_tree().set_input_as_handled() #would get bugs
			SaveManager.save_game()
			#pop from ui stack
			uiStack.pop()
			Events.emit_signal("request_show_message", "Game Saved!")
		OverworldMenu.LOAD:
			get_tree().set_input_as_handled()
			get_tree().paused = false #dont want it to be false when we go to the next scene
			SaveManager.load_game()
		OverworldMenu.EXIT:
			uiStack.pop() #get out of the menu
			#unpause
			get_tree().paused = false
#scene stack keeping things in memory that arent being processed but are still recieving signals
#updating the bar in the main scene but the bar isnt in the scene tree when we in battle
#this means that it cant create a tween
#can check so tht if animating the bar we will be in the scene tree

func _on_ItemList_resource_selected(resource : Item) -> void:
	item_resource = resource
	#remeber whats selected then push th context menu
	uiStack.push(context_menu)


func _on_ContextMenu_option_selected(option : int):
	match option:
		ContextMenu.USE:
			#print(item_resource.name)
			#if he have selected a healing item
			if item_resource is HealingItem:
				if stats.health < stats.max_health:
					#dont use the healing item if at full health
					use_healing_item(item_resource)
				else:
					info_menu.text = "Your health is already full"
					uiStack.push(info_menu)
		ContextMenu.INFO:
			info_menu.text = item_resource.description
			uiStack.push(info_menu)
