extends Node

static var debug : Debug

@export var overlay_outline_material : ShaderMaterial
		


func _ready() -> void:
	assert(overlay_outline_material, "No overlay outline material set")


func _process(_delta: float) -> void:
	
	debug.add_debug_property("FPS", Engine.get_frames_per_second(), 60)
	debug.add_debug_property("Mouse pos", get_viewport().get_mouse_position(), 1)
