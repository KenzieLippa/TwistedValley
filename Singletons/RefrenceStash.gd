extends Node
#because a resource and not a script then we need an instance of it

var turnManager := TurnManager.new()
#creates new instance of it and is stored in memory by storing it in a variable

#adds to th pool
var asyncTurnPool := AsyncTurnPool.new()

#can create a reference to our stats so we can make sure theres always something that is referencing the stuff
#if you reload a resource being used thts still in memory the un can reuse it
var playerStats : PlayerClassStats = load("res://Player/PlayerClassStats.tres")
#now when loaded it wont create a new instance itll just refrence the same instance already in memory
#causes it to be persistant accross th game
#want the inventory to be persistant as well
var inventory :Inventory  = load("res://Items/Inventory.tres")

var random_encounters := []
#updates every time we go into a room with a random encounter
var encounter_class : ClassStats

var player : KinematicBody2D 
