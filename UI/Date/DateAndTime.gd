extends Node2D
#class_name DateAndTime

signal update_min
signal update_hour
signal update_day
signal update_year
#variables
var minute : int = 0
var hour : int = 1
var day : int = 1
var year :int = 1


func _on_Minutes_timeout():
	#update minute
	#minute += 10
	emit_signal("update_min")
	print("update the minute")
