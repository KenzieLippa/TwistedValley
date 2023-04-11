extends Node2D

class_name State

var change_state
var animation
var persistant_state #not sure about this, may need to add this to player as well
var velocity = 0 #again is already in player so not sure how this will work

#here we are using the move and slide physics process, we are also using this in the plaer
#we will have to decide how to mix the two seemlessly
#since movement in the original is not super involved, it could be worth it to switch to this method
func _physics_process(delta):
	#not sure about the vector2.up
	persistant_state.move_and_slide(persistant_state.velocity, Vector2.UP)

func setup(change_state, animation, persistant_state):
	self.change_state = change_state #set it up like a property
	self.animation = animation
	self.persistant_state = persistant_state
