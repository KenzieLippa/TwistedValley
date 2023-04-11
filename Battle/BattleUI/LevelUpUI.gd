extends TextureRect

onready var experience_bar = $"%ExperienceBar"
#no matter where it is we can access it this way



func level_up() ->void:
	show()
	experience_bar.set_bar(50,100) #sets it at 50
	yield(experience_bar.animate_bar(100, 100), "completed")#animates to 75

