extends Node2D

const ZOOM_IN = Vector2(0.75,0.75)
const ZOOM_DEFAULT = Vector2.ONE
#const CENTER = Vector2(160,90) #this is the center of our window
#want to access th turn manager, create a new turn manager
#want to access with other stuff as well
#u can either make th turn manager a node and make it a signleton
#or you can make a refrences stash node
var turnManager : TurnManager = RefrenceStash.turnManager
var asyncTurnPool : AsyncTurnPool = RefrenceStash.asyncTurnPool

var ai : AI

onready var player_battle_unit := $PlayerPosition/PlayerBattleUnit
onready var enemy_battle_unit := $EnemyPosition/EnemyBattleUnit
onready var animation_player := $AnimationPlayer
onready var timer := $Timer

onready var player_battle_unit_info := $BattleUI/PlayerBattleUnitInfo
onready var enemy_battle_unit_info := $BattleUI/EnemyBattleUnitInfo
onready var battle_camera := $BattleCamera
onready var level_up_sound = $LevelUpSound


onready var center_position : Vector2 = $CenterRoot/CenterPoint.rect_global_position #will always be the same no matter th screen size
onready var enemy_camera_position : Vector2 = get_battle_unit_camera_position(enemy_battle_unit)
onready var player_camera_position : Vector2 = get_battle_unit_camera_position(player_battle_unit)
onready var level_up_ui = $"%LevelUpUI"
#onready var battle_menu = $"%BattleMenu"
onready var battle_menu_manager = $"%BattleMenuManager"

#currently the werewolf is being shared and therefore has no health

func _ready()->void:
	#play the music
	MusicPlayer.push_song(MusicPlayer.battle_music)
	#set the info slider to the players stats
	#print("Player ")
	var encounter_class : ClassStats = RefrenceStash.encounter_class
	if encounter_class is ClassStats:
		enemy_battle_unit.stats = encounter_class.duplicate() #so the werewolf is a new one each time instead of the shared dead one
		
		
	#(player_battle_unit.stats)
	#print(enemy_battle_unit.stats)
	player_battle_unit_info.stats = player_battle_unit.stats
	enemy_battle_unit_info.stats = enemy_battle_unit.stats
	#get access to our enemy ai here
	#make sure that enemy has ai, throws error if not
	assert(enemy_battle_unit.stats.ai is Script)
	ai = enemy_battle_unit.stats.ai.new() #new for a script to call a new instance of the ai
	# add ai as a child of th scene
	add_child(ai)
	#print("Before Yield")
	#queue_free() #waits till end of frame to destroy
	#yielding down the tree so if animation player is destroyed it will never finish
	yield(animation_player, "animation_finished") #yield until the animation finished signal
	turnManager.connect("ally_turn_started", self, "_on_ally_turn_started")
	turnManager.connect("enemy_turn_started", self, "_on_enemy_turn_started")
	turnManager.start()
	asyncTurnPool.connect("turn_over", self, "_on_async_turn_pool_turn_over")
#	yield(get_tree().create_timer(1.0), "timeout")#this will cause an error 
	# resume: Resumed function '_ready()' after yield, but script is gone. At script: res://Battle/Battle.gd:11
	#call down (call func on children) signal up
	#always yield down the scene tree because if you yield down if node is destroyed then it destroys all children
	#so then will not have a child alive to signal
	#print("After yield")
	#emmits signal when animation over
	#yield exits out of a func and doesnt do th next thing, then waits on th signal
	#once recieves th signal then comes back into th func and plays the battle unit attack
	#yield can cause bugs tho
		#if we yield on animation but then battle scene is destroyed but th animation player is not in our scene
		#emmits signal cause done but then godot tries to go back into the func and finish it
		#but now the battle node is dead so godot is trying to go back into a func that no longer exists
		#get error message
	#player_battle_unit.melee_attack()


#func _unhandled_input(event : InputEvent) -> void:
#	#built in func tht handles input
#	if event.is_action_pressed("ui_accept"):
#		SceneStack.pop()
		
func get_battle_unit_camera_position(battle_unit : BattleUnit) -> Vector2:
	var final_position := Vector2()
	var start = Vector2(battle_unit.global_position.x, center_position.y) #y always center but not always with th x
	#move towards the center a little bit
	final_position = start.move_toward(center_position, 32)
	return final_position

func battle_won() ->void:
	timer.start(0.5)
	yield(timer, "timeout")
	var previous_level : int = player_battle_unit.stats.level
	player_battle_unit.stats.experience += 105
	if player_battle_unit.stats.level > previous_level:
		#we know we have leveled up
		level_up_sound.play() #play the level up sound
		yield(level_up_ui.level_up(), "completed") #yielding down cause then we get destroyed before it does
		#("Level UP!")
	timer.start(0.5)
	yield(timer, "timeout")
	
func exit_battle() -> void:
	#fade out the song
	MusicPlayer.pop_song()
	#wait a sec then exit
#	timer.start(1.0)
#	yield(timer, "timeout")
	yield(Transition.fade_to_color(Color.black), "completed")
	Transition.fade_from_color(Color.black) #fade from the color after we have faded to th color
	SceneStack.pop()
	
#connect signals to functions
func _on_ally_turn_started() ->void:
	if not is_instance_valid(player_battle_unit):
		#timer.start(1.0)
		#yield(timer, "timeout")
		get_tree().quit()
		return #if the player died then quit the game
	
	yield(battle_menu_manager.show_battle_menu(), "completed")
	#dont need anymore cause new manager is doing this for us
	#battle_menu.grab_action_focus() #grab focus on the action button
	var selected_resource : Resource = yield(battle_menu_manager, "battle_menu_resource_selected") #returns tht value
	#battle_menu.hide_menu() no longer needed
	#match(option):
	#(selected_resource.name)
	if selected_resource is MeleeBattleAction:
		#match on type
#		match selected_resource.type:
#			DamageBattleAction.Type.MELEE:
			#do when ranged
		#BattleMenu.ACTION:
			#use the camera to focus
		battle_camera.focus_target(enemy_camera_position, ZOOM_IN)
				#not needed anymore, replaced this with the selected resource button
				#var battle_action = player_battle_unit.stats.battle_actions.front()#grab the front of the list
		#set focus on battle menu and yieldto make sure they select something
		#print("ally turn started") #good to make sure th framework is correct before u add to it
		#no longer need to yield on any of this stuff
		player_battle_unit.melee_attack(enemy_battle_unit, selected_resource) #returns a function state and then can yield until completed signal
			
	elif selected_resource is RangedBattleAction:
			#DamageBattleAction.Type.RANGED:
				#for the ranged attack
		player_battle_unit.ranged_attack(	enemy_battle_unit, selected_resource)
	#if we turn off the timers and dont wait on them
		#BattleMenu.ITEM:
	#check to see if defending
	elif selected_resource.name == "Defend":
		#add to the turn pool
		asyncTurnPool.add(self)
		#turns on the defend action, currently wont end the battle, added nothing to th pool
		player_battle_unit.defend = true
		#use a timer
		timer.start(1.0)
		yield(timer, "timeout") #wait until the timer is over
		asyncTurnPool.remove(self) #remove self afterwards
	elif selected_resource is Item:
		#selected action
		player_battle_unit.use_item(player_battle_unit, selected_resource)
	elif selected_resource.name == "Run":
		exit_battle()
			#print("Item")
			#turnManager.advance_turn()

			 #stops the battle
	#put in to simulate animation that will play, will happen too often so therefore will cause a stack overflow
	#its an infinite loop without the timer in between them, its getting called over and over again
	#but we can wait until they are done attacking
	#timer.start(1.0)
	#yield(timer, "timeout") #cant start in th yield
	#turnManager.advance_turn()
	
func _on_enemy_turn_started()->void:
	#print("enemy turn started")
	#disconnect this for now because doesnt have proper animations setup rn
	if not is_instance_valid(enemy_battle_unit) or enemy_battle_unit.is_queued_for_deletion():
		yield(battle_won(), "completed") #yield until finished, if finished then exit the battle
		#need yields in the battle won for the yield here to work
		exit_battle() #exit the battle scene
		return #dont want to run the attack if not valid
	
	#need to check to see what type of battle action we have
	#select action based on stats
	var battle_action = ai.select_battle_action(enemy_battle_unit.stats)
	#now replacing with AI
	#enemy_battle_unit.stats.battle_actions.front()#grab the front of the list
	
	if battle_action is MeleeBattleAction:
		#then run this code
		battle_camera.focus_target(player_camera_position, ZOOM_IN)
		enemy_battle_unit.melee_attack(player_battle_unit, battle_action)
	elif battle_action is RangedBattleAction:
		enemy_battle_unit.ranged_attack(player_battle_unit, battle_action)
	elif battle_action.name == "Defend":
		#add to the turn pool
		asyncTurnPool.add(self)
		#turns on the defend action, currently wont end the battle, added nothing to th pool
		enemy_battle_unit.defend = true
		#use a timer
		timer.start(1.0)
		yield(timer, "timeout") #wait until the timer is over
		asyncTurnPool.remove(self)
	#timer.start(1.0)
	#yield(timer, "timeout")
	#turnManager.advance_turn()
	
#when we get th signal from async then we end th turn
func _on_async_turn_pool_turn_over() -> void:
	#go back to center and yield to make sure done
	yield(battle_camera.focus_target(center_position, ZOOM_DEFAULT), "completed")
	turnManager.advance_turn()
