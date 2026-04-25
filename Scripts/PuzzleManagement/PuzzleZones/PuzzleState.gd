@icon("res://assets/Textures/EditorIcons/PuzzleZoneState.svg")
class_name PuzzleState
extends Node


@export var is_final_state: bool
@export var object_positions: Dictionary[int, Vector3]
@export var npc_interpretations: Dictionary[int, Interpretation]