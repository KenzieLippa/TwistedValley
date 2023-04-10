extends Node

class_name Math

static func chance(percent : float) -> bool:
	#return a random value between 0 and 1
	return randf() <= percent
	#bc static then we dnt need to instance th class without an instance
