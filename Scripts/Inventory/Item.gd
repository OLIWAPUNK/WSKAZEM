class_name Item
extends Area3D

@export var item_data: ItemData

func _ready() -> void:
	assert(item_data.identifier != null and item_data.identifier != "", "Item data must have an identifier")
	if item_data.item_name == null or item_data.item_name == "":
		item_data.item_name = item_data.identifier
	
	var mesh: MeshInstance3D
	for children in get_children():
		if children is MeshInstance3D:
			mesh = children
			break
	assert(mesh, "There is no mesh in Item")
	item_data.mesh = mesh.mesh
