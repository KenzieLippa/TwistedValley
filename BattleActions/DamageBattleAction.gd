extends BattleAction
class_name DamageBattleAction

#want to instead make one for melee and for ranged
#enum Type {MELEE, RANGED}
#can list the type of battle actions that each character has access to

#export(Type) var type := Type.MELEE #sets the default to meleee
export(int) var damage := 5 #will calc this into th attacks later, for now this is th default
