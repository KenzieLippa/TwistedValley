extends Node

#most likely will remove this
#var date = RefrenceStash.dateAndTime
onready var hour = $"%Hour"
onready var minute = $"%Minute"
onready var am_pm = $"%AmPm"
onready var day = $"%Day"
onready var year = $"%Year"
onready var season = $"%Season"


func _ready():
	Events.connect("update_time", self, "_update_time")

func _update_time():
	if EnviromentStash.currHour < 13: 
		hour.text = " " + str(EnviromentStash.currHour)
		am_pm.text = " AM"
	else:
		hour.text = " " + str(EnviromentStash.currHour - 12)
		am_pm.text = " PM"
		
	if EnviromentStash.currMinute != 0:
		minute.text = str(EnviromentStash.currMinute)
	else:
		minute.text = "00"
	day.text = " Day: "+str(EnviromentStash.currDay)
	season.text = " Season: "+str(EnviromentStash.currSeason)
	#print(EnviromentStash.currSeason)
	year.text = " Year: "+ str(EnviromentStash.currYear)
	
