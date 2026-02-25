class_name DroppedItemsManager
extends Node3D

const DROPPED_ITEM_SCENE = preload("res://Scenes/GameWorld/Items/DroppedItem.tscn")
const CAN_BE_GRABBED_SCENE = preload("res://Scenes/GameWorld/Traits/CanBeGrabbed.tscn")

func _ready() -> void:
	assert(Global.dropped_items_manager == null, "There should only be one DroppedItemsManager in the scene")
	Global.dropped_items_manager = self

func drop(held_item: ItemData):
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
	var item_scene = load(held_item.scene_path)
	var dropped_item: RigidBody3D = DROPPED_ITEM_SCENE.instantiate()
	add_child(dropped_item)
	var item = item_scene.instantiate() as Item
	dropped_item.add_child(item)
	item.add_child(CAN_BE_GRABBED_SCENE.instantiate())
	dropped_item.global_transform.origin = valid_direction
	dropped_item.linear_velocity = (valid_direction - from).normalized() * 3 + Vector3.DOWN * 2
	return true