extends Resource
class_name AsyncTurnPool

#active nodes that are being used currently
var active_nodes := []

#when everything is out and things are over
signal turn_over

#when something is running and gets added
func add(node: Node) ->void:
	active_nodes.append(node)
	
func remove(node : Node) -> void:
	#prevent characters from removing themselves from the pool when they arent in it
	#if none active then shldnt need to remove any
	if active_nodes.empty(): return
	active_nodes.erase(node)
	#if empty after we removed one we wanna run this
	#get rid of th node u wanna and then emit the signal that things are over
	if active_nodes.empty(): emit_signal("turn_over")
	
#if you had multiple enemies and players you would have multiple units
#you would have to take this into account with ur turn manager
#give each unit an active status
#if any active when u loop thru then u wld execute their turns
#loop thru see if no more active and then go back to th heros turns
#need this bc of th branch in th timeline
