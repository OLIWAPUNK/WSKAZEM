class_name PuzzleZone
extends Node

@export var npcs: Dictionary[String, CanBeTalkedTo]
@export var cutscene_collection: CutsceneCollection
@export var states: Array[PuzzleZoneState]

@export var states_transition: Dictionary[Vector2i, String]

var current_state_index: int = 0


func change_state(new_state: PuzzleZoneState) -> void:

    var new_state_index = states.find(new_state)
    if new_state_index == -1:
        push_warning("State not found in PuzzleZone %s" % self)
    
    var transition_key = Vector2i(current_state_index, new_state_index)
    var cutscene_name = states_transition.get(transition_key)

    if not cutscene_name:
        push_warning("No transition found in %s" % self)
        return

    await Global.cutscene_manager.play_cutscene(cutscene_collection.cutscene_identifier, cutscene_name)

    current_state_index = new_state_index
    states[new_state_index].brain_controll()
