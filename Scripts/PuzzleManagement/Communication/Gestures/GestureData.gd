@icon("res://assets/Textures/EditorIcons/GestureData.svg")
class_name GestureData
extends Resource

signal gesture_pressed(data: GestureData)

@export var name: String
@export var animation_name: String
enum gestureCategory {NONE, ITEM, EMOTE}
@export var type: gestureCategory = gestureCategory.NONE

@export var display_texture: Texture2D

var user_description: String = ""



func pressed() -> void:

	gesture_pressed.emit(self)
