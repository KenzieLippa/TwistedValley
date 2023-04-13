extends Node

#access the current time, day and season
#var currTime : String = "12:00"
var currDay : int = 1
var currYear = 1 #will need to add this to th save file
enum Seasons {SPRING, SUMMER, FALL, WINTER} 
var currSeason = Seasons.SPRING
enum Weather {SUNNY, CLOUDY, RAINING, SNOWING}
var currWeather = Weather.SUNNY
var currMinute = 0
var currHour = 9
#var dateAndTime = preload("res://Time/Date/DateAndTime.tscn")
#var date_and_time = DateAndTime.instance()

#var date_and_time = RefrenceStash.dateAndTime

func _ready():
	#should possibly be process we will see
	DateAndTime.connect("update_min", self, "_on_update_min")
	
func _on_update_min():
	#currMinute = DateAndTime.minute
	currMinute +=10
	if currMinute >= 60:
		currMinute = 0
		update_hour()
	#print("Time: "+str(currHour)+ ":", str(currMinute) + "\n"
	#+"day: " + str(currDay) + " Season: "+ str(currSeason) + " Year: " + str(currYear))
	Events.emit_signal("update_time")
func update_hour():
	currHour +=1
	if currHour > 24:
		currHour = 1
		update_day()
	
func update_day():
	currDay +=1
	if currDay > 28:
		currDay = 1
		update_season()
	
func update_season():
	currSeason += 1
	if currSeason > 4:
		currSeason = 1
		update_year()
	
func update_year():
	currYear +=1


