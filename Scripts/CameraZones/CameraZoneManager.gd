class_name CameraZoneManager
extends Node

var zones: Array[CameraZone] = []
var current_zone: CameraZone = null

func _ready() -> void:
	for node in find_children("*"):
		if node is CameraZone:
			node.connect("body_shape_entered", node.body_shape_entered)
			node.connect("body_shape_exited", node.body_shape_exited)

			zones.append(node)