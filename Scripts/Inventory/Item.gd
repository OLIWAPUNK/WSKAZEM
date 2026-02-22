class_name Item
extends Area3D

@export var identifier: String
@export var item_name: String

func _ready() -> void:
	assert(identifier != null and identifier != "", "Item must have an identifier")
	if item_name == null or item_name == "":
		item_name = identifier
	
	var mesh: MeshInstance3D
	for children in get_children():
		if children is MeshInstance3D:
			mesh = children
			break
	assert(mesh, "There is no mesh in Item")
