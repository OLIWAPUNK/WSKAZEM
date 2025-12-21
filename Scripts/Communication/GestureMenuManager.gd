class_name GestureMenuManager
extends Node

var gesture_list: Array[GestureData]
@export var starting_gestures: Array[GestureData]

var gesture_tile = preload("res://Scenes/UI/GestureTile.tscn")

@onready var menu_container: VBoxContainer = $"../ColumnContainer"

var menu_rows: Array[HBoxContainer]
var row_capacity: int = 3
var last_row_count = 0



func _ready() -> void:

	add_row()

	for gesture in starting_gestures:

		var new_tile = gesture_tile.instantiate()

		var new_tile_button = new_tile.get_node("ButtonContainer/Gesture")

		new_tile_button.texture_normal = gesture.display_normal
		new_tile_button.texture_hover = gesture.display_hover
		new_tile_button.texture_pressed = gesture.display_pressed

		new_tile_button.connect("pressed", gesture.pressed)
		gesture.connect("gesture_pressed", gesture_pressed)

		add_tile(new_tile)


func gesture_pressed(gesture: GestureData) -> void:

	print(gesture.name)


func add_tile(new_tile: Control) -> void:

	if last_row_count >= row_capacity:
		add_row()

	menu_rows.back().add_child.call_deferred(new_tile)
	last_row_count += 1


func add_row() -> void:

	var new_row = HBoxContainer.new()
	new_row.custom_minimum_size = Vector2(0, 100)

	menu_rows.append(new_row)
	menu_container.add_child.call_deferred(new_row)

	last_row_count = 0


func add_gesture(new_gesture: GestureData) -> void:

	if new_gesture in gesture_list:
		return

	gesture_list.append(new_gesture)
