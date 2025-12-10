class_name CameraZoneManager
extends Node

var zones: Array[CameraZone] = []
var current_zone: CameraZone = null

func _ready() -> void:
	var zone_manager_count := 0
	for node in get_tree().root.find_children("*"):
		if node is CameraZoneManager:
			zone_manager_count += 1

	assert(zone_manager_count <= 1, "There should be not more than one CameraZoneManager in the scene.")

	for node in find_children("*"):
		if node is CameraZone:
			node.connect("body_shape_entered", node.body_shape_entered)
			node.connect("body_shape_exited", node.body_shape_exited)

			zones.append(node)