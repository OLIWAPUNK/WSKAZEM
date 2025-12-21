class_name GestureMenuManager
extends Node

var gesture_list: Array[GestureData]
@export var starting_gestures: Array[GestureData]

var gesture_tile = preload("res://Scenes/UI/GestureTile.tscn")
@onready var menu_container: VBoxContainer = $".."



func _ready() -> void:

	gesture_list = starting_gestures

	for gesture in gesture_list:

		var new_tile = gesture_tile.instantiate()
		new_tile.get_node("TextureRect").texture = gesture.display_icon

		$'../GestureRow'.add_child.call_deferred(new_tile)


func add_gesture(new_gesture: GestureData) -> void:

	if new_gesture in gesture_list:
		return

	gesture_list.append(new_gesture)
