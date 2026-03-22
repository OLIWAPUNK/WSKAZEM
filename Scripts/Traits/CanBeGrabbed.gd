@icon("res://assets/Textures/EditorIcons/Grabable.svg")
class_name CanBeGrabbed
extends CanBeClicked

func _init() -> void:
	overlay_outline_material = preload("res://assets/Materials/ItemOutline.tres")
	
func _ready() -> void:
	super._ready()
	assert(parent.get_parent() is Item, "CanBeGrabbed must be a grandchild of an Item")
	
