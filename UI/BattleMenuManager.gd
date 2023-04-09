extends Control

const RUN_BATTLE_ACTION = preload("res://BattleActions/RunBattleAction.tres")

var elizabeth_stats : PlayerClassStats = RefrenceStash.elizabethStats
var inventory : Inventory = RefrenceStash.inventory
var uiStack := UIStack.new() #can create and use where needed
var selected_resource : Resource 

onready var battle_menu = $"%BattleMenu"
#fill with el battle actions then connect to them right away
onready var action_list = $"%ActionList"
onready var item_list = $"%ItemList"
onready var context_menu = $"%ContextMenu"
onready var info_menu = $"%InfoMenu"
#will need to update buttons in list when items change
signal battle_menu_resource_selected(selected_resource)

func _ready() ->void:
	action_list.fill(elizabeth_stats.battle_actions)
	#fill action and items list
	#item list fills itself now so we don't have to worry about it
	#item_list.fill(elizabeth_stats.inventory.items)
	#action_list.grab_button_focus() #using a temp func
#	yield(battle_menu.show_menu(), "completed") #show the menu
#	#battle_menu.grab_focus()
#	uiStack.push(battle_menu) #push th battle menu
func show_battle_menu() -> void:
	yield(battle_menu.show_menu(), "completed")
	uiStack.push(battle_menu)

func _unhandled_input(event : InputEvent) -> void:
	#can only cancel if greater than one
	if event.is_action_pressed("ui_cancel") and uiStack.uis.size() > 1:
		uiStack.pop()#can access what its popping but currently dont need to
		#old system
#		action_list.release_focus()
#		item_list.release_focus()
#		#has to be afterwards in order to remeber which was last focused
#		#this is because once hidden its sending the thing to be null
#		#if we hide then all th things arent shown and therefor are not able to be accessed to be stored to be remeberd
#		action_list.hide() #assumed we on action list initialize
#		item_list.hide()
#		battle_menu.grab_focus()

func _on_BattleMenu_menu_option_selected(option : int) -> void:
	match option:
		BattleMenu.ACTION:
			#old shit
#			battle_menu.release_focus()#release focus on th bottom part so prevents users for interacting with it
#			action_list.show()
#			action_list.grab_focus()
			uiStack.push(action_list) #push on the action list
				
		BattleMenu.ITEM:
#			battle_menu.release_focus()
#			item_list.show()
#			item_list.grab_focus()
			uiStack.push(item_list)
		BattleMenu.RUN:
			#hide the menu
			battle_menu.hide()
			battle_menu.release_focus()
			#emit the signal and the run battle action
			emit_signal("battle_menu_resource_selected", RUN_BATTLE_ACTION)
#want to push context menu to stack

func _on_ActionList_resource_selected(resource : BattleAction) -> void:
	uiStack.push(context_menu)
	#set the selected resource to the current resource
	selected_resource = resource
	#print(resource.name)


func _on_ItemList_resource_selected(resource : Item) -> void:
	uiStack.push(context_menu)
	selected_resource = resource
	#print(resource.name)


func _on_ContextMenu_option_selected(option : int) -> void:
	match option:
		ContextMenu.USE:
			
			#pop twice
#			uiStack.pop()
#			uiStack.pop()
#			battle_menu.release_focus()
#clear th stack and show th menu
#dont want menu to be hidden
#because we using clear each ui isnt able to remeber what we were last on
			#dont use, just pop twice
			#uiStack.clear()
			#battle_menu.show()
			uiStack.pop()
			uiStack.pop() #two down 
			battle_menu.release_focus() # prevent from being stupid
			battle_menu.hide_menu()
			#removing in here
			if selected_resource is Item:
				#remove the selected resource
				inventory.remove_item(selected_resource)
			emit_signal("battle_menu_resource_selected", selected_resource)
		ContextMenu.INFO:
			#make sure we have something
			if selected_resource is Item or selected_resource is BattleAction:
				info_menu.text = selected_resource.description #start by showing the name
				uiStack.push(info_menu)
			#print some info about the info about the resource we have selected
