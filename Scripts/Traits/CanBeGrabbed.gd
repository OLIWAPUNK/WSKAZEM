@icon("res://Textures/EditorIcons/Grabable.svg")
class_name CanBeGrabbed
extends CanBeClicked

func _init() -> void:
	overlay_outline_material = preload("res://Materials/ItemOutline.tres")