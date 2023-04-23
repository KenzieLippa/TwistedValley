extends KinematicBody2D

const WALK_SPEED = 80
const MAX_ENCOUNTER_METER := 100 #every certain chance we gonna try to enter a new encounter
const MIN_ENCOUNTER_CHANCE := 0.1 #use this as our first chance, if failed then will incrament in the next go around
const ENCOUNTER_METER_REDUCTION := 75

var velocity := Vector2.ZERO #strict typing, give extra info so it doesnt type other stuff
var encounter_meter := MAX_ENCOUNTER_METER #set this to the max but this value will be updated
var encounter_chance := MIN_ENCOUNTER_CHANCE
var last_door_connection = -1
#type autimatically to what u think it shld be
# Called every frame. 'delta' is the elapsed time since the previous frame.
#tell godot tht shld always be a float and then telling specifically that theres no return value
onready var animatedSprite := $AnimatedSprite
onready var interactable_detector := $InteractableDetector
onready var item_detector = $ItemDetector

onready var enter_new_area := $Sounds/EnterNewArea
onready var use_door := $Sounds/UseDoor

#init func where checks to see if player is already real or na
func _init() -> void:
	#only called when initiialized, since bringing over from the other one
	#will only destroy the new one
	#does level swapper have a player
	if LevelSwapper.player is KinematicBody2D:
		queue_free()

func _ready():
	#will crash if we change rooms
	#only set if level swapper doesnt have the player
	if not LevelSwapper.player is KinematicBody2D:
		RefrenceStash.player = self #save ourselves into th refrence stash
	#LevelSwapper.player = self #set our self to the level swapper player
	interactable_detector.rotation = Vector2.DOWN.angle()
# warning-ignore:unused_argument
func _physics_process(delta : float) -> void:
	#returns the vector that is what ever u are pressing
	#need negative x then pos x, negative y then pos y for th get vector func, returns what ever is 
	#collected as the input
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#get vector already normalizes it so we dont need to re-normalize, even th diags will be 1
	#if not then u can use .normalized()
	velocity = input_vector * WALK_SPEED #makes sure that wherever your going its 1
# warning-ignore:return_value_discarded
	move_and_slide(velocity) #pass in the velocity, already mults by delta
	
	if is_moving():
		animate_walk()
		#rotate around both
		interactable_detector.rotation = velocity.angle()
		item_detector.rotation = velocity.angle()
		encounter_check(delta)#if moving then pass in
	else:
		animate_idle()

		
func _unhandled_input(event : InputEvent) -> void:
	#built in func tht handles input
	if event.is_action_pressed("ui_accept"):
		#SceneStack.push("res://Battle/Battle.tscn")
		#works with phyisics bodies, wont work with area 2d unless u use areas
		var interactables : Array = interactable_detector.get_overlapping_bodies()
		for interactable in interactables:
			if not interactable is Interactable: continue
			interactable._run_interaction()
			get_tree().set_input_as_handled()
			
#also the key we use to hide the menu, 
#if we are below the ui in the scene we wont be able to see it
#input is propegating from the player up there and isnt acting as handled
	if event.is_action_pressed("ui_cancel"):
		#show the overworld menu
		Events.emit_signal("request_show_overworld_menu")
		get_tree().set_input_as_handled()
		#test message system
		#Events.emit_signal("request_show_message", "You pressed the space key!")
		
func encounter() -> void:
	#his is under is moving
	var random_encounters = RefrenceStash.random_encounters
	if random_encounters.empty(): return #if nothing in there then return
	random_encounters.shuffle() #shuffle them up then pick th front
	RefrenceStash.encounter_class = random_encounters.front() #storing it here so we have access in battle
	get_tree().paused = true
	yield(Transition.fade_to_color(Color.white), "completed")
	#set the color to transpar
	Transition.set_color(Color.transparent)
	#unpause
	get_tree().paused = false
	
	#push battle scene on
	SceneStack.push("res://Battle/Battle.tscn")
	
func encounter_check(delta : float) -> void:
	#can add things like grass checks so its not as annoying
	encounter_meter -= ENCOUNTER_METER_REDUCTION * delta 
	#print(encounter_meter)
	if encounter_meter <= 0:
		encounter_meter = MAX_ENCOUNTER_METER
		if Math.chance(encounter_chance):
			#if it is then we had an encounter, set back to min and engage!
			encounter_chance = MIN_ENCOUNTER_CHANCE
			encounter() #engage!
			#print("encounter!")
		else:
			#set the encounter chance up, makes sure its never higher than 1
			encounter_chance = min(encounter_chance + 0.1, 1.0)
func is_moving() -> bool:
	#returns a bool
	return velocity != Vector2.ZERO #if not zero then we know we moving
	
func animate_walk() -> void:
	#convert the velocity to an angle, then check it to see where we moving
	#based on th angle we will animate th sprite
	#snap to 45s to make sure we get th angle exact
	var angle : float = velocity.angle()
	#convert to dgress cause radians used by defaults
	var angle_in_degrees : float = rad2deg(angle)
	#we get how many 45s fit into the angle then round it to th nearest val 
	var rounded_angle : int = int(round(angle_in_degrees/45)*45) #round what it is before we mult back up to 45
	match(rounded_angle):
		#all of these are variations of left, up left, straight left and down left
		-135, 180, 135: animatedSprite.animation = "WalkLeft"
		0, -45, 45: animatedSprite.animation = "WalkRight"
		-90: animatedSprite.animation = "WalkUp"
		90: animatedSprite.animation = "WalkDown"
			
func animate_idle() -> void:
	match(animatedSprite.animation):
		"WalkLeft" : animatedSprite.animation = "IdleLeft"
		"WalkRight" : animatedSprite.animation = "IdleRight"
		"WalkUp" : animatedSprite.animation = "IdleUp"
		"WalkDown" : animatedSprite.animation = "IdleDown"

func go_to_new_area(new_area_path : String) -> void:
	#enter_new_area.play() #make sure to play sound even while paused
	#reset the encounter meter
	get_tree().paused = true
	yield(Transition.fade_to_color(Color.black), "completed")
	get_tree().paused = false
	encounter_meter = MAX_ENCOUNTER_METER
	#swap the area we are at
	LevelSwapper.level_swap(self, new_area_path)
	Transition.fade_from_color(Color.black) #fade from black
	
func _on_DoorDetector_area_entered(door : Area2D) -> void:
	#print("this is a door")
	if not door is Door: return
	#not a func but a variable and then the empty func
	if door.new_area.empty(): return #if area isnt set in the inspector, return
	last_door_connection = door.connection #remeber where the connection is coming from
	#use call deffered to wait to go to new area
	if door.door_sound_effect:
		use_door.play()
	else:
		enter_new_area.play()
	call_deferred("go_to_new_area", door.new_area) #waits to allow godot to be ready
	

#when the area is entered



func _on_ItemDetector_area_entered(item):
	print("area was entered")
	if not item is FarmItem: return
	if item != null:
		#get item details and print them
		var itemDetails = InventoryManager.get_item_details(item.item_code)
		print(itemDetails)
		
