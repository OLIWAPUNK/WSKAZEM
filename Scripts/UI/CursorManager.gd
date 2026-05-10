extends Node

enum CursorType {
	DEFAULT,
	PRESS,
	GRAB,
	DOOR,
	TALK
}

var cursor_textures = {
	CursorType.DEFAULT: preload("res://assets/Textures/Cursor/Cursor.png"),
	CursorType.PRESS: preload("res://assets/Textures/Cursor/Press.png"),
	CursorType.GRAB: preload("res://assets/Textures/Cursor/Grab.png"),
	CursorType.DOOR: preload("res://assets/Textures/Cursor/Door.png"),
	CursorType.TALK: preload("res://assets/Textures/Cursor/Talk.png")
}

func _ready():
	Input.set_custom_mouse_cursor(cursor_textures[CursorType.PRESS], Input.CURSOR_POINTING_HAND)
	set_cursor(CursorType.DEFAULT)

func set_cursor(cursor_type: CursorType) -> void:
	assert(cursor_type in cursor_textures, "Invalid cursor type: %s" % cursor_type)
	Input.set_custom_mouse_cursor(cursor_textures[cursor_type], Input.CURSOR_ARROW)