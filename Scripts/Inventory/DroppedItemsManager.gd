class_name DroppedItemsManager
extends Node3D

func _ready() -> void:
	assert(Global.dropped_items_manager == null, "There should only be one DroppedItemsManager in the scene")
	Global.dropped_items_manager = self

func drop(item: Item):
	var ray_directions = [
		Vector3(0, 0, 1),
		Vector3(0, 0, -1),
		Vector3(1, 0, 0),
		Vector3(-1, 0, 0),
	].map(func (dir): return dir.rotated(Vector3.UP, Global.player.global_rotation.y)) as Array[Vector3]
	var player = Global.player
	var space_state = player.get_world_3d().direct_space_state
	var from = player.global_transform.origin
	var valid_direction = Vector3.ZERO
	for direction in ray_directions:
		var to = from + direction
		to.y += 1
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(query)
		if not result:
			valid_direction = to
			break
	if valid_direction == Vector3.ZERO:
		return false
	add_child(item)
	item.global_transform.origin = valid_direction
	item.linear_velocity = (valid_direction - from).normalized() * 3 + Vector3.DOWN * 2
	return true
