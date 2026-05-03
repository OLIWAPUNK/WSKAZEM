@icon("res://assets/Textures/EditorIcons/Clickable.svg")
class_name CanBeClicked
extends Node

@onready var parent: Node = $".."

@export var mesh_path: String = ""
@export var is_disabled: bool = false

@export var standing_point: Node3D

var overlay_outline_material : ShaderMaterial
var mesh: MeshInstance3D

func _find_deep_mesh(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node

	for child in node.get_children():
		var result = _find_deep_mesh(child)
		if result:
			return result

	return null
	

func _ready() -> void:
	assert(parent is Area3D, name + " must be a child of an Area3D")
	

	if mesh_path == "":
		mesh = _find_deep_mesh(parent)
	else:
		mesh = parent.get_node(mesh_path)
	assert(mesh, name + " has no mesh")

	parent.connect("mouse_entered", on_hover)
	parent.connect("mouse_exited", on_unhover)
	

func on_hover() -> void:
	if is_disabled:
		return

	if Global.player_controls_disabled or Global.ui_manager.is_visible():
		return

	if overlay_outline_material:
		mesh.material_overlay = overlay_outline_material
	Global.pointer_manager.on_hover(self)
	

func on_unhover() -> void:
	if is_disabled:
		return

	mesh.material_overlay = null
	Global.pointer_manager.on_unhover(self)
