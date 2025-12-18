class_name Clickable
extends Node

# signal object_clicked(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int)

@onready var parent : Area3D = $".."

var mesh : MeshInstance3D



func _ready() -> void:

	for child in parent.get_children():

		if child is not MeshInstance3D: 
			continue

		assert(not mesh, "There are more meshes in clickable")
		mesh = child

	parent.connect("mouse_entered", on_hover)
	parent.connect("mouse_exited", on_unhover)


func on_hover() -> void:

	mesh.material_overlay = Global.overlay_outline_material
	%PointerManager.on_hover(self)
	

func on_unhover() -> void:

	mesh.material_overlay = null
	%PointerManager.on_unhover(self)
