extends Node

var stack := []

onready var town_music = $TownMusic
onready var battle_music = $BattleMusic

#will have a music stack
func push_song(song : AudioStreamPlayer)-> void:
	#if already a song on track then pause it
	if not stack.empty(): stack.back().stream_paused = true
	stack.append(song)
	song.play()
	
func pop_song()-> void:
	if stack.empty(): return
	var current_song : AudioStreamPlayer = stack.pop_back()
	var volume_fade = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	volume_fade.tween_property(current_song, "volume_db", -50.0, 0.25).from_current()
	yield(volume_fade, "finished") #once the song has fully faded out
	current_song.stop() #stop the song
	current_song.volume_db = 0.0 #set the volume back to full
	var last_song : AudioStreamPlayer = stack.back() #get the previous song
	last_song.volume_db = -50.0
	last_song.stream_paused = false #unpause the last song
	#fade it in
	var volume_rise = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	volume_rise.tween_property(last_song, "volume_db", 0.0, 1.0).from_current()
