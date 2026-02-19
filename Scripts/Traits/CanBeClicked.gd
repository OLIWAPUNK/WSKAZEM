class_name CanBeClicked
extends Node

@onready var parent: Area3D = $".."

@export var standing_point: Node3D


var overlay_outline_material : ShaderMaterial
var mesh: MeshInstance3D


func _ready() -> void:
	for child in parent.get_children():

		if child is not MeshInstance3D: 
			continue

		assert(not mesh, "There are more meshes in clickable")
		mesh = child

	parent.connect("mouse_entered", on_hover)
	parent.connect("mouse_exited", on_unhover)


func on_hover() -> void:

	if Global.player_controls_disabled:
		return

	if overlay_outline_material:
		mesh.material_overlay = overlay_outline_material
	%PointerManager.on_hover(self)
	

func on_unhover() -> void:

	mesh.material_overlay = null
	%PointerManager.on_unhover(self)

