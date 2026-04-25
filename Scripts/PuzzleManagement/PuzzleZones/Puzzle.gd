@icon("res://assets/Textures/EditorIcons/PuzzleZone.svg")
class_name Puzzle
extends Node


# Jeśli zagadka nie jest aktywna, to npc w 0. stanie nie ma next_puzzle_state
@export var is_active: bool = true
@export var activator_entry: String
var is_cleared: bool = false
@export var progress_entry: String

@export var state_list: Array[PuzzleState]
var current_state_index: int

@export var object_dictionary: Dictionary[int, Node3D]
@export var npc_dictionary: Dictionary[int, Area3D]

@export var transitions: Dictionary[Vector2i, String]
@onready var animation_package: AnimationPackage = get_parent().animation_package


func _ready() -> void:
	assert(is_active or activator_entry == "", "Inactive %s without activator" % self)
	assert(activator_entry == "" and is_active, "Activator entry set but %s is active" % self)
	
	if is_cleared:
		return

	for npc in npc_dictionary.values():
		var npc_trait: CanBeTalkedTo = npc.get_node("CanBeTalkedTo")
		if not npc_trait:
			push_warning("%s has no CanBeTalkedTo" & npc)
			return
		npc_trait.change_puzzle_state.connect(change_state)

	if activator_entry != "":
		print(activator_entry)
		is_active = Global.progress_tracker.chceck_status(activator_entry)

	if is_active:
		for npc in npc_dictionary.values():
			npc.get_node("CanBeTalkedTo").is_disabled = false
	else:
		Global.progress_tracker.updated_progress.connect(updated_progress_for_activation)

	# TUTAJ WCZYTAJ SAVE

	setup_state(current_state_index)


func updated_progress_for_activation(entry: String) -> void:
	if entry != activator_entry:
		return

	print(self, " AKTYWOWANY")
	for npc in npc_dictionary.values():
		npc.get_node("CanBeTalkedTo").is_disabled = false


func check_activation() -> void:
	pass


func change_state(state_index: int) -> void:
	if is_cleared:
		return

	print("Called new state: ", state_index)
	
	var animation_name = transitions.get(Vector2i(current_state_index, state_index))
	if not animation_name:
		push_error("No transition from %d to %d" % [current_state_index, state_index])
		return

	current_state_index = state_index
	animation_package.call_by_name(animation_name)
	setup_state(current_state_index)


func setup_state(state_index: int) -> void:

	var current_state: PuzzleState = state_list.get(state_index)
	
	for index in object_dictionary.keys():
		object_dictionary[index].position = current_state.object_positions[index] # NIE DZIALA

	for index in npc_dictionary.keys():
		npc_dictionary[index].get_node("CanBeTalkedTo").npc_interpretation = current_state.npc_interpretations[index]

	if current_state.is_final_state:
		is_cleared = true
		for npc in npc_dictionary.values():
			npc.get_node("CanBeTalkedTo").is_disabled = true
		Global.progress_tracker.update(progress_entry, self)
