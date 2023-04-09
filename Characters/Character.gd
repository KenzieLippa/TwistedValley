extends Resource

class_name Character

#have access to this data if we need
export(String) var name
export(Texture) var portrait
export(float, 0.5, 1.5, 0.1) var voice_pitch = 1.0
#gives us diff pitches
