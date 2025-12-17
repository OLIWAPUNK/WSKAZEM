extends Node

static var debug : Debug
		


func _process(_delta: float) -> void:
	debug.add_debug_property("FPS", Engine.get_frames_per_second(), 60)


func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("ui_cancel"):

		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
