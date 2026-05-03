class_name DroppedItemsManager
extends Node3D

func _ready() -> void:
	assert(Global.dropped_items_manager == null, "There should only be one DroppedItemsManager in the scene")
	Global.dropped_items_manager = self

	if not is_in_group("GameEvents"):
		add_to_group("GameEvents")

	var dropped_items_data = Saves.get_data_or_null("dropped_items." + get_scene_key())
	if dropped_items_data != null:
		for child in get_children():
			if child is Item:
				child.queue_free()
		for item_data in dropped_items_data:
			item_data = item_data as Dictionary
			var item_scene = load(item_data["scene_file_path"])
			if item_scene:
				var item_instance = item_scene.instantiate()
				if item_instance is Item:
					add_child(item_instance)
					item_instance.global_transform = SerDeUtil.deserialize_transform3d(item_data["global_transform"])
					item_instance.linear_velocity = SerDeUtil.deserialize_vector3(item_data["linear_velocity"])
				else:
					push_error("The scene at %s is not an Item!" % item_data["scene_file_path"])
			else:
				push_error("Failed to load dropped item scene at path: %s" % item_data["scene_file_path"])

func drop(item: Item, dropper: Node3D) -> bool:
	var ray_directions = [
		Vector3(0, 0, 1),
		Vector3(0, 0, -1),
		Vector3(1, 0, 0),
		Vector3(-1, 0, 0),
	].map(func (dir): return dir.rotated(Vector3.UP, dropper.global_rotation.y)) as Array[Vector3]
	var space_state = dropper.get_world_3d().direct_space_state
	var from = dropper.global_transform.origin
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

func get_scene_key() -> String:
	return Global.map_manager.get_current_scene_path().replace(".", "_")

func on_save():
	var dropped_items_data = []
	for item in get_children():
		if item is Item:
			dropped_items_data.append({
				"scene_file_path": item.scene_file_path,
				"global_transform": SerDeUtil.serialize_transform3d(item.global_transform),
				"linear_velocity": SerDeUtil.serialize_vector3(item.linear_velocity),
			})
	Saves.set_data("dropped_items." + get_scene_key(), dropped_items_data)
