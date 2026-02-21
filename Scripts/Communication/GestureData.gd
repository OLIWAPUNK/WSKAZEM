class_name GestureData
extends Resource

signal gesture_pressed(data: GestureData)

@export var name: String
enum gestureCategory {NONE, DIRECTION}
@export var type: gestureCategory = gestureCategory.NONE
@export_group("Display Textures")
@export var display_normal: Texture2D
@export var display_hover: Texture2D
@export var display_pressed: Texture2D

var user_description: String = ""



func pressed() -> void:

    gesture_pressed.emit(self)
