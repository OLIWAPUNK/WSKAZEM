class_name InventoryManager
extends Node

@onready var item_mesh: MeshInstance3D = %ItemMesh
@onready var button: Button = $"../SlotContainer/Button"

# var held_item: ItemData = null
var held_item: ItemData = preload("res://Resources/Items/RockItem.tres")

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
	item_object.queue_free()

func drop():
	_set_held_item(null)

func _set_held_item(item: ItemData):
	held_item = item
	if held_item:
		item_mesh.mesh = held_item.mesh
		item_mesh.visible = true
		button.disabled = false
		button.tooltip_text = "Drop held item"
	else:
		item_mesh.mesh = null
		item_mesh.visible = false
		button.disabled = true
		button.tooltip_text = ""