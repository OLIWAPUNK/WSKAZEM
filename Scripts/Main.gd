extends Node


var debug : Debug
var map_manager : MapManager
var camera_zone_manager : CameraZoneManager
var cutscene_manager : CutsceneManager
var ui_manager : UIManager
var pointer_manager : PointerManager
var player : CharacterBody3D
var dropped_items_manager : DroppedItemsManager
var player_controls_disabled : bool = false
var state_machine : StateMachine

@export var PRINT_TEST_STEPS: bool = false
@export var PRINT_TALK: bool = false
@export var PRINT_GATE_PATH: bool = false


func end_game():
	get_tree().change_scene_to_file("res://Scenes/UI/EndScreen.tscn")

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Saves.save()
		get_tree().quit()