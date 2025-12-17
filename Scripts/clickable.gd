extends Node

@onready var parent := $".."

var mesh : MeshInstance3D



func _ready() -> void:
	
	for child in parent.get_children():

		if child is not MeshInstance3D: 
			continue

		mesh = child

	print(mesh)
	parent.connect("input_event", clickable_clicked)
	parent.connect("mouse_entered", on_hover)
	parent.connect("mouse_exited", on_unhover)


func on_hover() -> void:

	mesh.material_overlay = Global.overlay_outline_material


func on_unhover() -> void:

	mesh.material_overlay = null


func clickable_clicked(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if Input.is_action_just_pressed("go_to_point"):

		print(parent)