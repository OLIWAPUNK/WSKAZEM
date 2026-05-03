class_name InventoryManager
extends Node

@onready var item_mesh: MeshInstance3D = %ItemMesh
@onready var button: Button = $"../SlotContainer/Button"

@export var item_gesture_dict: Dictionary[String, GestureData]

var held_item: Item = null

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)

	Global.inventory_manager = self

	if not is_in_group("GameEvents"):
		add_to_group("GameEvents")

	var held_item_path = Saves.get_data_or_null("held_item")
	if held_item_path != null and held_item_path != "":
		var held_item_scene = load(held_item_path)
		if held_item_scene:
			var held_item_instance = held_item_scene.instantiate()
			if held_item_instance is Item:
				held_item = held_item_instance
			else:
				push_error("The scene at %s is not an Item!" % held_item_path)
		else:
			push_error("Failed to load held item scene at path: %s" % held_item_path)

	_set_held_item(held_item)

func _on_button_pressed() -> void:
	drop()

func grab(object: CanBeGrabbed):
	var item: Item = object.parent.get_parent()
	drop()
	_set_held_item(item.duplicate())
	item.queue_free()

func drop():
	if not held_item:
		return
	if Global.ui_manager.is_visible():
		var gesture_menu_manager = Global.ui_manager.gesture_menu_manager
		if gesture_menu_manager.message_has_item >= 0:
			return
		var index = gesture_menu_manager.message.size()
		gesture_menu_manager.add_message_tile(item_gesture_dict[held_item.name], index)
		gesture_menu_manager.message_has_item = index
		return
	if Global.dropped_items_manager.drop(held_item, Global.player):
		clear_item()

func clear_item():
	_set_held_item(null)

func _set_held_item(item: Item):
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

func on_save():
	Saves.set_data("held_item", held_item.scene_file_path if held_item else "")
