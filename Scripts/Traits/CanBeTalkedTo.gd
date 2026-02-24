@icon("res://Textures/EditorIcons/Talkable.svg")
class_name CanBeTalkedTo
extends CanBeClicked

@export var npc_interpretation: Interpretation


func _init() -> void:
	overlay_outline_material = preload("res://Materials/NPCOutline.tres")


func tell(message: Array[GestureData]) -> void:

	var mes = " ".join(message.map(func(gesture_data: GestureData) -> String:
		return gesture_data.name
	))

	print(self, " OTRZYAMLEM [ ", mes, " ]")
	if npc_interpretation:
		npc_interpretation.interpret(message)