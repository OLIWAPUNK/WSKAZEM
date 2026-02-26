extends Node


static var debug : Debug
static var map_manager : MapManager
static var cutscene_manager : CutsceneManager
static var ui_manager : UIManager
static var pointer_manager : PointerManager
static var player_controls_disabled : bool = false
static var state_machine : StateMachine


@export var PRINT_TEST_STEPS: bool = false


func _process(_delta: float) -> void:
	
	debug.add_debug_property("FPS", Engine.get_frames_per_second(), 60)
	debug.add_debug_property("Mouse pos", get_viewport().get_mouse_position(), 1)
