@icon("res://assets/Textures/EditorIcons/GestureData.svg")
class_name GestureData
extends Resource

signal gesture_pressed(data: GestureData)

@export var name: String
@export var animation_name: String
enum gestureCategory {NONE, ITEM}
@export var type: gestureCategory = gestureCategory.NONE

@export_flags("Emote") var is_npc = 0

@export_group("Display Textures")
@export var display_normal: Texture2D # TODO: Currently emotes use this field for their texture, in the future they should have their own field
@export var display_hover: Texture2D
@export var display_pressed: Texture2D

var user_description: String = ""



func pressed() -> void:

	gesture_pressed.emit(self)
