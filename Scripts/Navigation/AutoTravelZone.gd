class_name AutoTravelZone
extends Area3D

@export var travel_point: Node3D

func _ready() -> void:
	assert(travel_point, "%s: AutoTravelZone has no travel_point assigned" % name)
	connect("mouse_entered", _on_hover)
	connect("mouse_exited", _on_unhover)

func _on_hover():
	if Global.player_controls_disabled or Global.ui_manager.is_visible():
		return

	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

	Global.pointer_manager.on_hover(self)

func _on_unhover():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	Global.pointer_manager.on_unhover(self)
