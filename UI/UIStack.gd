extends Resource
class_name UIStack

var uis := []
#will keep track of the UIS, whats in focus and doing input
#remebers all uis that have led us to this point
#will handle grabing and releasing focus of those menus
signal ui_popped(ui)
signal ui_stack_empty()

func push(uiToPush : Control) -> void:
	if not empty(): uis.back().release_focus() #focus ont he top (back) ui 
	#grabbing focus on whats added 
	uis.append(uiToPush)
	uiToPush.show() #make sure visible
	uiToPush.grab_focus() #wont work if not visible
	
func pop() -> Control:
	if empty(): return null
	#cant pop if nothing there
	var uiToPop : Control = uis.pop_back() # get the back node again and pop
	#this also gets this
	uiToPop.release_focus() #must release focus before hiding or it will not work 
	uiToPop.hide()
	if not empty():
		#must again show before we can focus
		#if stuff is still in the list grab the top element
		uis.back().show()
		uis.back().grab_focus()
	emit_signal("ui_popped", uiToPop)
	if empty():
		emit_signal("ui_stack_empty")
	return uiToPop
	
func hide_uis()->void:
	for ui in uis:
		#release focus as well, stupid idea because it deletes ALL focus
		#ui.release_focus()
		ui.hide()
		
func clear() -> void:
	#we are hiding the uis but not releasing focus, wld be wise to release focus too
	hide_uis()
	uis.clear() #hiding them and then clear the refrences to the uis
	
func empty() -> bool:
	return uis.empty()
