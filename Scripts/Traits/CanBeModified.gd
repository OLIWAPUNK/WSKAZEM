@icon("res://assets/Textures/EditorIcons/Modifiable.svg")
class_name CanBeModified
extends CanBeClicked

@export var required_item_identifier: String = ""

func _init() -> void:
	overlay_outline_material = preload("res://assets/Materials/ModifiableOutline.tres")

func _ready():
	super._ready()
	assert(required_item_identifier != "", "%s doesn't have item identifier set!" % name)

func apply(identifier: String):
	if identifier != required_item_identifier:
		return

	print("correct")
