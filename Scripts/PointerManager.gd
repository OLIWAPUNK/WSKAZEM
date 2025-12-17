extends Node

var clickable_nodes : Array[Node]


func add_clickable(node: Clickable) -> void:

	clickable_nodes.append(node.parent)
	node.connect("object_clicked", clickable_clicked)
	

func clickable_clicked(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	print("click")
