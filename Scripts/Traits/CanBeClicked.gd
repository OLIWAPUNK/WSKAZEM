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

	print_debug("Hovering over ", parent.name)
	
	if Global.player_controls_disabled or %GameUI/CommunicationContainer.visible:
		return

	if overlay_outline_material:
		mesh.material_overlay = overlay_outline_material
	%PointerManager.on_hover(self)
	

func on_unhover() -> void:

	print_debug("Unhovering over ", parent.name)

	mesh.material_overlay = null
	%PointerManager.on_unhover(self)
