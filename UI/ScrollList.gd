extends FocusMenu
class_name ScrollList

 #get access to elizabthes stats
const ResourceButtonScene := preload("res://UI/ResourceButton.tscn")
#fill using these stats
#onready var resource_button = $MarginContainer/ScrollContainer/MarginContainer/ButtonContainer/ResourceButton
onready var scroll_container := $"%ScrollContainer"
onready var button_container := $"%ButtonContainer"

signal resource_selected(resource)

#func grab_button_focus() -> void:
#	#will be changing later
#	#fill(elizabeth_stats.battle_actions) #fill with the battle actions
#	#resource_button.grab_focus() #grabs the focus of th input
#	#godot tries to create focus neighbors, tries to calculate it, if there is no seperation then it wont work
#	#connect_scroll_children() #connects all th chillins
#	#grab focus on the first button
#	button_container.get_child(0).grab_focus()
##need to know when focus has entered one of the buttons

#try to do as much as u can statically in the editor
#if you cant then do dynamic in code
func fill(resource_list : Array) -> void:
	#set what we can and cannot focus on 
	for resource in resource_list:
		#create a resource button
		var resource_button : ResourceButton = add_resource_button()
		#resource in the list we are gonna store in the resource button 
		resource_button.resource = resource
		resource_button.text = resource.name
	connect_scroll_children() #connect when ever we fill the data
	
func add_resource_button() -> ResourceButton:
	var resource_button : ResourceButton = ResourceButtonScene.instance()
	button_container.add_child(resource_button)
	#add as a child
	focus_nodes.append(resource_button.get_path())
	#when its selected has a signal that emits th signal
	resource_button.connect("resource_selected", self, "_on_resource_selected")
	return resource_button
		
func clear() -> void :
	for button in button_container.get_children():
		button.queue_free() #frees the button from the queue
	focus_nodes.clear() #list of the node paths we are focusing on, clear this when we clear that
	
	
func connect_scroll_children() -> void:
	for button in button_container.get_children():
		if button.is_connected("focus_entered", self, "_on_button_focused"):continue
		button.connect("focus_entered", self, "_on_button_focused")

#doing the follow focus on our own
func _on_button_focused() -> void:
	#yield(get_tree(), "idle_frame") didnt actually fix the problem
	#isnt remebering what button we are on
	var focused_button := get_focus_owner()
	# if the button found is not in the list of buttons then exit
	if not focused_button in button_container.get_children(): return
	var focused_scroll_amount := get_focused_scroll_amount()
	#create the tween
	var tween := create_tween()
	tween.tween_property(scroll_container, "scroll_vertical", focused_scroll_amount, 0.1).from_current() 
	
func get_focused_scroll_amount() -> int:
	var focused_button := get_focus_owner() #get the current focused button
	#get previous scroll from where it was before then update to make sure its visible
	var previous_scroll : int = scroll_container.scroll_vertical
	scroll_container.ensure_control_visible(focused_button)
	#what scroll amount do we need to make this button visible
	#set it to the scroll amount, then get it, then set it back
	var focused_scroll_amount : int = scroll_container.scroll_vertical
	#want to manually move it through a tween
	scroll_container.scroll_vertical = previous_scroll
	return focused_scroll_amount

#need a func to fill scroll list with data

func _on_resource_selected(resource : Resource) ->void:
	#print(resource.name) #print for now to see if working
	emit_signal("resource_selected", resource)#emits the signal with the resource we found
