class_name AutoTravelZone
extends Area3D

@export var travel_point: Node3D

@export_category("Map change")
@export var scene: PackedScene
@export var target_position: Vector3
@export var next_pallete: PaletteManager.Palette = PaletteManager.Palette.MONO

func _ready() -> void:
	assert(travel_point, "%s: AutoTravelZone has no travel_point assigned" % name)
	connect("mouse_entered", _on_hover)
	connect("mouse_exited", _on_unhover)
	if scene:
		connect("body_shape_entered", _on_body_shape_entered)

func _on_hover():
	if Global.player_controls_disabled or Global.ui_manager.is_visible():
		return

	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

	Global.pointer_manager.on_hover(self)

func _on_unhover():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	Global.pointer_manager.on_unhover(self)

func _on_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if not body is CharacterBody3D:
		return

	Global.palette_manager.set_palette(next_pallete)
	Global.map_manager.go_to_scene(scene.resource_path).connect(_on_scene_before_load)

func _on_scene_before_load():
	Global.map_manager.scene_before_load.disconnect(_on_scene_before_load)
	Global.player.global_transform.origin = get_tree().root.get_node("World").global_transform.origin + target_position
