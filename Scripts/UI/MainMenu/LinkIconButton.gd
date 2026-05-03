extends Button

@export var url: String = ""

func _ready() -> void:
	connect("pressed", _on_pressed)
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _on_pressed() -> void:
	if url != "":
		OS.shell_open(url)		
