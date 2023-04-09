extends Node2D

class_name BattleUnit
#cant preload the scene because of a cyclical dependancy
#const PROJECTILE = preload("res://Projectiles/Projectile.tscn")
#can refrence in code while using strict typing
const ATTACK_OFFSET = 48
const KNOCKBACK_AMOUNT = 24

#use this to ensure we all using the same turn pool
var asyncTurnPool : AsyncTurnPool = RefrenceStash.asyncTurnPool

export(Resource) var stats setget set_stats

var battle_animations :BattleAnimations
var defend : bool = false setget set_defend

#get global position which we only have access too once we've been instanced as a child
onready var root_position := global_position
onready var battle_shield = $BattleShield
onready var impact_sound := $ImpactSound
onready var impact_defend_sound = $ImpactDefendSound
onready var defend_sound = $DefendSound
onready var heal_sound = $HealSound


func set_stats(value: ClassStats) -> void:
	stats = value
	if not stats is ClassStats: return #if wrong then just exit out
	#if we change it then we swap it out we want to remove the other battle animations
	if battle_animations is BattleAnimations : battle_animations.queue_free()
	battle_animations = stats.battle_animations.instance()
	add_child(battle_animations)
	
#set defence
func set_defend(value : bool ) -> void:
	defend = value
	#set either visible or not using whether or not defend is tru
	battle_shield.visible = defend
	if defend == true:
		defend_sound.play()
#func _exit_tree() -> void:
	#this is the reason its crashing here
	#asyncTurnPool.remove(self) #remove from the turn pool when we die
#func _ready() ->void:
#	if stats is ClassStats:
#		#
#		battle_animations = stats.battle_animations.instance()
#		add_child(battle_animations)
#
#will need to take in a target so that you know who to attack
#might not let us use BattleUnit cause its cyclical
func melee_attack(target : BattleUnit, battle_action : MeleeBattleAction) -> void:
	asyncTurnPool.add(self) #adding self to turn pool
	#first wanna play the approach animation
	#make sure we in front
	z_index = 10
	battle_animations.play("Approach") 
	var target_position := target.global_position.move_toward(global_position, ATTACK_OFFSET) #gives us a position close to the wolf not right on it
	var animation_duration := battle_animations.get_current_animation_length() #gets the current animations length
	interpolate_position(global_position, target_position, animation_duration) #then the other two have defaults
	#the targets global position but with an offset
	#play hit but we need to wait until the next one
	#we are yielding on a child so this will be fine
	yield(battle_animations, "animation_finished")
	#now play the next animation
	#would look weird to yield on this func
	#print("Attack")
	deal_damage(target, battle_action)
	#want this func to run at th same time as the attack animations
	#but it cld end up taking longer which wld be bad
	#dont know which one is gonna finish first and therefore dont know when to end the turn
	target.take_hit(self) # we attacking the target so we th attacker, then we run th take hit
	battle_animations.play("Melee")
	yield(battle_animations, "animation_finished")
	#now we have attacked 
	
	battle_animations.play("Return")
	animation_duration = battle_animations.get_current_animation_length()
	interpolate_position(global_position, root_position, animation_duration)
	yield(battle_animations, "animation_finished") #seems to be replaying this a bunch
	#go back to idle
	battle_animations.play("Idle")
	z_index = 0 #set it back
	#remove self once done with actions
	asyncTurnPool.remove(self)
	
func ranged_attack(target : BattleUnit, battle_action : RangedBattleAction) -> void:
	#add self to the turn pool
	asyncTurnPool.add(self)
	#play animation
	battle_animations.play("RangedAnticipation")
	#yield on animation finished
	yield(battle_animations, "animation_finished")
	
	#remove the typing and itll work
	#load dont preload for the typing in the projectile to work
	#var projectile = load("res://Projectiles/Fireball.tscn").instance()
	#now we can use the projectile we added to the object
	var projectile = battle_action.projectile.instance()
	#add as a child
	add_child(projectile) #add child to the current scene
	projectile.global_position = battle_animations.get_emission_position() #creates at our feet sadly
	#move the projectile
	#currently goes to the feet
	projectile.move_to(target)
	#this is questionable because the projectile is not a child of the scene
	#could crash
	projectile.connect("contact", self, "ranged_attack_hit", [target, battle_action], CONNECT_ONESHOT) #pass in at th end through an array for multi params
	#connect one shot is a flag we can connect so that it only gets called once and never again
#	yield(projectile, "contact") #wait for the signal
#	#deal the damage
#	deal_damage(target, battle_action)
#	target.take_hit(self)#make the target take the hit
#
	battle_animations.play("RangedRelease")
	yield(battle_animations, "animation_finished")
	battle_animations.play("Idle")
	#remove self from turn pool
	asyncTurnPool.remove(self)
	
func use_item(target : BattleUnit, item : Item) -> void:
	asyncTurnPool.add(self) #add self
	battle_animations.play("ItemAnticipation")
	yield(battle_animations, "animation_finished") #wait till finished
	stats.health += item.heal_amount
	#play the healing sound
	heal_sound.play()
	battle_animations.play("ItemRelease")
	yield(battle_animations, "animation_finished")
	battle_animations.play("Idle")
	#remove self from turn pool
	asyncTurnPool.remove(self)
	
func ranged_attack_hit(target : BattleUnit, battle_action : BattleAction) ->void:
	#doing what th above code does
	deal_damage(target, battle_action)
	target.take_hit(self)
	
func deal_damage(target: BattleUnit, battleAction : DamageBattleAction) ->void:
	#crazy damage calculation using all th stats and such
	#now we want to account for our specific battle action so it matters what we use
	#reduces damage by half
	var damage = ((stats.level * 3 + (1- target.stats.defense *0.05)) /2) * ((stats.attack + (battleAction.damage/5)) /6)
	#use the target not the other one
	#play diff sound effects depending on whether or not we playing
	if target.defend:
		impact_defend_sound.play()
		#turn it off
		target.defend = false
		damage = round(damage/2) #take half damage
	else:
		impact_sound.play()
	target.stats.health -= damage
	#print(damage)
	#print(target.stats.health)
	
func take_hit(attacker: BattleUnit) ->void:
	
	asyncTurnPool.add(self)
	#creating a refrence point, cld be on right or left side, if on right wanna move in one way and we care about who is attacking us
	#move away from the direction of th person attacking us, this is basically like using move away
	
	var knockback_position := global_position.move_toward(attacker.global_position, -KNOCKBACK_AMOUNT)
	#trans circle is like exponent but more circular, then ease out will slow down at the end
	interpolate_position(global_position, knockback_position, 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT)
	#play the hit animation
	 #will continue to play after movement has stopped
	
	if stats.health ==0:
		battle_animations.play("Death")
		yield(battle_animations, "animation_finished")
		#at some points we dont want it removing itself so therefore moving it 
		asyncTurnPool.remove(self) #here we shld remove ourselves from the turn pool
		#this is better because otherwise we were removing ourselves when th process was ending and it was crashing
		queue_free()
		return #dont want to interpolate position
	else:
		#if still alive then play th hit and yield till finished
		battle_animations.play("Hit")
		yield(battle_animations, "animation_finished")
		battle_animations.play("Idle")
		#do need to remove self from the turn pool
	#has to finish before this func is completed
	yield(interpolate_position(global_position, root_position, 0.2, Tween.TRANS_CIRC), "completed")
	asyncTurnPool.remove(self)
#linear and ease in out wont work together but also wont break
func interpolate_position(start : Vector2, end : Vector2, duration : float, trans : int = Tween.TRANS_LINEAR, easing : int = Tween.EASE_IN_OUT) -> void:
	#lots of arguments for this function
	#create a tween
	var tween = create_tween().set_trans(trans).set_ease(easing) #uses the arguments we have
	#sets a transition and easing type right away, then every time you tween after it will use this trans and ease type
	tween.tween_property(self, "global_position", end, duration).from(start) #tween the property global position
	#tweens from start
	yield(tween, "finished") #can now also yield on this function too until its finished
	#always yield down the scene tree..... except rn
	#fine to yield on th tween for what ever reason, its the one exception, can yield on a tween created this way
	
