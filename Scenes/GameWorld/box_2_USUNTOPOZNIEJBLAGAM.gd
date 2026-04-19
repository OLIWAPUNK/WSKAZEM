extends MeshInstance3D

@export var podloga_machen: Node3D


func _ready() -> void:
	get_node("Znikaj").connect("receive", zniknij_pudlo)

func zniknij_pudlo(_name):
	print("ZNIKAM")
	podloga_machen.add_to_group("Ground")
