extends Resource
#nodes are in th scene tree
#resource is a refrence in memory
#sprite node is node and texture assigned is a resource
class_name TurnManager

enum {ALLY_TURN, ENEMY_TURN}

var turn := ALLY_TURN setget set_turn

signal ally_turn_started()
signal ally_turn_ended()
signal enemy_turn_started()
#signal enemy_turn_ended()

func set_turn(value : int) ->void:
	turn = value #enums are ints
	match(turn):
		ALLY_TURN:
			#just matched ally turn
			emit_signal("ally_turn_started")
		ENEMY_TURN:
			emit_signal("ally_turn_ended") #first we notify the ally turn ended
			emit_signal("enemy_turn_started")#then we emit tht the enemy turn has started
			
func start() -> void:
	#starts at th ally turn
	self.turn = ALLY_TURN #forces to emit th signal
	
func advance_turn() -> void:
	#can use if but we wanna use fancyness
	self.turn = int(self.turn+1)&1 #uses a binary operator
	#if our value is 0 then ally turn and this will set to 1 which is enemy turn
	#if is 1 then will set to 0
	
