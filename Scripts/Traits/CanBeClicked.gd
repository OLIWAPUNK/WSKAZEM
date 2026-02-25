class_name CanBeClicked
extends Node

@onready var parent: Node = $".."

@export var standing_point: Node3D

var overlay_outline_material : ShaderMaterial
var mesh: MeshInstance3D


func _ready() -> void:
	assert(parent is Area3D, "CanBeClicked must be a child of an Area3D")

	for child in parent.get_children():

		if child is not MeshInstance3D: 
			continue

		assert(not mesh, "There are more meshes in CanBeClicked")
		mesh = child

	assert(mesh, "There is no mesh in CanBeClicked")

	parent.connect("mouse_entered", on_hover)
	parent.connect("mouse_exited", on_unhover)


func on_hover() -> void:

	if Global.player_controls_disabled or Global.ui_manager.is_visible():
		return

	if overlay_outline_material:
		mesh.material_overlay = overlay_outline_material
	Global.pointer_manager.on_hover(self)
	

func on_unhover() -> void:

	mesh.material_overlay = null
	Global.pointer_manager.on_unhover(self)
