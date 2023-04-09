extends Node

var stack := []

func push(path : String) ->void:
	var tree := get_tree() #gets th scene tree
	#want to save and remeber th old main node
	var main : Node = tree.current_scene
	stack.append(main) #adds this to the stack
	#now we want access to th root
	var root := tree.root #gets the root of the tree
	root.remove_child(main)#remove the main child but dont destroy it
	#normally the switch scene deletes it but we have not
	var next_scene : Node = load(path).instance()#load what ever we pushed to th stack and instance it
	root.add_child(next_scene)
	tree.current_scene = next_scene
	#so we are taking the town and storing it in th stack so its in memory
	#swapping out th scenes manually, do not delete
	
func pop()->void:
	if stack.empty():
		return #dont do anything
	var tree := get_tree()
	var root := tree.root
	tree.current_scene.queue_free()#when popping something we are completely getting rid of it
	var previous_scene : Node = stack.pop_back() #grab th latest thing in th stack
	root.add_child(previous_scene)
	tree.current_scene = previous_scene
#grab scene we remeber from before and adding it back
func clear() ->void:
	#clears of everything in it and frees all in stack
	for scene in stack:
		scene.queue_free()
	stack.clear() #no more things in it
