class_name Clickable
extends Node

@onready var parent: Area3D = $".."
var mesh: MeshInstance3D

@export var standing_point: Node3D



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

	mesh.material_overlay = Global.overlay_outline_material
	%PointerManager.on_hover(self)
	

func on_unhover() -> void:

	mesh.material_overlay = null
	%PointerManager.on_unhover(self)


func tell(message: Array[GestureData]) -> void:

	var mes = ""
	for m in message:
		mes += " " + m.name

	print(self, " OTRZYAMLEM [", mes, " ]")
