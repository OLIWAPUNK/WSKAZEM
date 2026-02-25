class_name DroppedItemsManager
extends Node3D

func _ready() -> void:
	assert(Global.dropped_items_manager == null, "There should only be one DroppedItemsManager in the scene")
	Global.dropped_items_manager = self
