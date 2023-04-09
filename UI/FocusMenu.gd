extends Control

class_name FocusMenu

#want to disable and enable focus on specific nodes
#need to know whether a node should or should not be enabled
#putting the open braces there creates a shared list so remove the = []
#leave it like this instead
export(Array, NodePath) var focus_nodes : Array
#allows to us to tell which nodes shld be focused and which shld be disable
#want to remeber our last node focused
var last_focus_node : Control

func grab_focus() -> void:
	#grab focus on the last if it can or on all the focus nodes
	if not can_grab_focus(): return
	set_focus_mode(Control.FOCUS_ALL) #set to focus all
	#double check if it exsist and if is control
	if is_instance_valid(last_focus_node) and last_focus_node is Control:
		last_focus_node.grab_focus()
		return
	var focus_node = get_node(focus_nodes.front()) #get the front node
	focus_node.grab_focus() #if th last doesnt end anything grab the first one
		
func release_focus() ->void:
	#get access to the first focus owner
	var current_focus : Control = get_focus_owner()
	if not current_focus is Control : return 
	last_focus_node = current_focus #set the last focus node before releasing focus so can remeber
	current_focus.release_focus()
	set_focus_mode(Control.FOCUS_NONE)

func can_grab_focus() -> bool:
	return (
		is_instance_valid(last_focus_node)
		and last_focus_node is Control
		or not focus_nodes.empty()
	)
	
func set_focus_mode(mode : int) ->void:
	#get access to that node
	for focus_node_path in focus_nodes:
		var focus_node : Control = get_node(focus_node_path)
		focus_node.focus_mode = mode
