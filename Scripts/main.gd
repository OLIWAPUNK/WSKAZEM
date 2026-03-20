extends Node


static var debug : Debug
static var map_manager : MapManager
static var camera_zone_manager : CameraZoneManager
static var cutscene_manager : CutsceneManager
static var ui_manager : UIManager
static var pointer_manager : PointerManager
static var player : CharacterBody3D
static var dropped_items_manager : DroppedItemsManager
static var player_controls_disabled : bool = false
static var state_machine : StateMachine

@export var PRINT_TEST_STEPS: bool = false