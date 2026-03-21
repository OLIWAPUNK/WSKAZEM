extends Node


var debug : Debug
var map_manager : MapManager
var cutscene_manager : CutsceneManager
var ui_manager : UIManager
var pointer_manager : PointerManager
var player : CharacterBody3D
var dropped_items_manager : DroppedItemsManager
var player_controls_disabled : bool = false
var state_machine : StateMachine

@export var PRINT_TEST_STEPS: bool = false

func end_game():
	get_tree().change_scene_to_file("res://Scenes/UI/EndScreen.tscn")
