@icon("res://Textures/EditorIcons/Grabable.svg")
class_name CanBeGrabbed
extends CanBeClicked

func _init() -> void:
	overlay_outline_material = preload("res://Materials/ItemOutline.tres")
	
func _ready() -> void:
	super._ready()
	assert(parent is Item, "CanBeGrabbed must be a child of an Item")
	