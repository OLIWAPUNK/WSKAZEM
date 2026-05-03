@icon("res://assets/Textures/EditorIcons/Modifiable.svg")
class_name CanBeModified
extends CanBeClicked

@export var required_item_identifier: String = ""
@export var progress_key: String = ""
@export var should_consume_item: bool = true

func _init() -> void:
	overlay_outline_material = preload("res://assets/Materials/ModifiableOutline.tres")

func _ready():
	super._ready()
	assert(required_item_identifier != "", "%s doesn't have item identifier set!" % get_path())
	assert(progress_key != "", "%s doesn't have progress key set!" % get_path())

func apply(identifier: String):
	if identifier != required_item_identifier:
		return

	Global.progress_tracker.update(progress_key, self)
	if should_consume_item:
		Global.inventory_manager.clear_item()
