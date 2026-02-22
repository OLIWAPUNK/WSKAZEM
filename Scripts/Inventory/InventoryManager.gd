class_name InventoryManager
extends Node

var held_item: ItemData = null

func grab(object: CanBeGrabbed):
	var item_object: Item = object.parent
	if held_item:
		drop()
	held_item = item_object.item_data
	item_object.queue_free()

func drop():
	if held_item:
		held_item = null
