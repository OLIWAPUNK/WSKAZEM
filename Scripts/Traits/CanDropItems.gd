@icon("res://assets/Textures/EditorIcons/Grabable.svg")
class_name CanDropItems
extends Node

@export var items: Dictionary[String, PackedScene] = {}

@onready var parent: Node3D = $".."

func drop_item(item_name: String) -> void:
	assert(items.has(item_name), "Item name not found in items dictionary: " + item_name)
	var item_scene = items[item_name]
	var item_instance = item_scene.instantiate() as Item
	Global.dropped_items_manager.drop(item_instance, parent)