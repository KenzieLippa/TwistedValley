extends Label

#most likely will remove this
func _process(delta):
	var date = OS.get_datetime()
	EnviromentStash.currDay = date["day"]
	self.text = " Time: " + str(date["hour"]) + " : " + str(date["minute"])
