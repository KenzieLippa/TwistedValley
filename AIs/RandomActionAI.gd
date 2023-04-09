extends AI
#could create a saved var to remeber what has been used and not use again
func select_battle_action(class_stats : ClassStats)-> BattleAction:
	var actions = class_stats.battle_actions
	if actions.empty() : return null #if there is nothing in the actions list then return nothing
	actions.shuffle()
	return actions.front()#returns th front of th list
	#you can jump around in tutorials u know, u dnt have to watch them from start to finish
