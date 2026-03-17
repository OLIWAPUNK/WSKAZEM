@icon("res://assets/Textures/EditorIcons/Talkable.svg")
class_name CanBeTalkedTo
extends CanBeClicked

@export var npc_interpretation: Interpretation


func _init() -> void:
	overlay_outline_material = preload("res://assets/Materials/NPCOutline.tres")


func start_talking() -> void:
	
	if npc_interpretation:
		if npc_interpretation.endorsement and not npc_interpretation.endorsement_made:
			print(self, " ZACZYNA OD ", npc_interpretation.endorsement)

	npc_interpretation.endorsement_made = false


func tell(message: Array[GestureData]) -> void:
	if not npc_interpretation:
		return

	var mes = " ".join(message.map(func(gesture_data: GestureData) -> String:
		return gesture_data.name
	))

	print(self, " OTRZYAMLEM [ ", mes, " ]")
	var reaction := npc_interpretation.interpret(message)
	print(self, " ODPOWIADAM ", reaction)


func change_interpretation() -> void:
	pass