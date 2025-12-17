extends Node

var clickable_nodes : Array[Node]

func _ready() -> void:

	clickable_nodes = get_tree().get_nodes_in_group("Clickable")
	print(clickable_nodes)



func catch_clickable():

	print("pipa")
