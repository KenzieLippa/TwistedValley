extends YSort

func _ready() ->void :
	if MusicPlayer.stack.has(MusicPlayer.town_music): return
	#if this music is not playing then you should play it
	MusicPlayer.push_song(MusicPlayer.town_music)
	#SaveManager.save_game() #may have to move later?
