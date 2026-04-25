@icon("res://assets/Textures/EditorIcons/PuzzleZone.svg")
class_name Puzzle
extends Node


@export var is_active: bool
@export var activator_entry: String
var is_cleared: bool
@export var progress_entry: String

@export var state_list: Array[PuzzleState]
var current_state: int

@export var object_dictionary: Dictionary[int, Node3D]
@export var npc_dictionary: Dictionary[int, CanBeTalkedTo]

@export var transitions: Dictionary[Vector2i, String]


