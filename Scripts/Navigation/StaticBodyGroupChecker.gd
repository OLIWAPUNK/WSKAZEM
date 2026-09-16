extends NavigationRegion3D


func _ready() -> void:
	
	for child in get_children():
		if child is MeshInstance3D and child.is_in_group("Ground"):
			child.get_child(0).add_to_group("Ground")


