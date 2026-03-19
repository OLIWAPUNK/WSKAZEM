@icon("res://assets/Textures/EditorIcons/Reaction.svg")
class_name Reaction
extends Resource


@export var answer: Array[GestureData]


func _to_string() -> String:
    return "Reaction [ " + " ".join(answer.map(func(gesture_data: GestureData) -> String:
        return gesture_data.name
    )) + " ]"