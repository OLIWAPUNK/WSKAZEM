class_name InventoryManager
extends Node

@onready var item_mesh: MeshInstance3D = %ItemMesh
@onready var button: Button = $"../SlotContainer/Button"

const DROPPED_ITEM_SCENE = preload("res://Scenes/GameWorld/Items/DroppedItem.tscn")
const CAN_BE_GRABBED_SCENE = preload("res://Scenes/GameWorld/Traits/CanBeGrabbed.tscn")

var held_item: ItemData = null
# var held_item: ItemData = preload("res://Resources/Items/RockItem.tres")

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)

	_set_held_item(held_item)

func _on_button_pressed() -> void:
	drop()

func grab(object: CanBeGrabbed):
	var item_object: Item = object.parent
	if held_item:
		drop()
	_set_held_item(item_object.item_data)
	item_object.get_parent_node_3d().queue_free()

func drop():
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
		return
	var item_scene = load(held_item.scene_path)
	var dropped_item: RigidBody3D = DROPPED_ITEM_SCENE.instantiate()
	Global.dropped_items_manager.add_child(dropped_item)
	var item = item_scene.instantiate() as Item
	dropped_item.add_child(item)
	item.add_child(CAN_BE_GRABBED_SCENE.instantiate())
	dropped_item.global_transform.origin = valid_direction
	dropped_item.linear_velocity = (valid_direction - from).normalized() * 3 + Vector3.DOWN * 2
	_set_held_item(null)
	


func _set_held_item(item: ItemData):
	held_item = item
	if held_item:
		item_mesh.mesh = held_item.mesh
		item_mesh.scale = held_item.mesh_scale
		item_mesh.global_transform.origin.y += held_item.mesh_y_offset
		item_mesh.visible = true
		
		button.disabled = false
		button.tooltip_text = "Drop held item"
	else:
		item_mesh.visible = false
		item_mesh.mesh = null
		item_mesh.scale = Vector3.ONE
		item_mesh.global_transform.origin.y = 0
		
		button.disabled = true
		button.tooltip_text = ""
