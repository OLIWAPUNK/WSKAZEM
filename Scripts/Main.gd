extends Node

static var debug : Debug

func _process(_delta: float) -> void:
	debug.add_debug_property("FPS", Engine.get_frames_per_second(), 60)
