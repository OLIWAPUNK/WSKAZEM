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
var is_loading : bool = false
var progress_tracker : ProgressTracker
var game_viewport_container : SubViewportContainer
var palette_manager : PaletteManager
var inventory_manager : InventoryManager

const gesture_resources_path: String = "res://Resources/Gestures"
var all_gestures: Array[GestureData] = []

@export var PRINT_TEST_STEPS: bool = false
@export var PRINT_TALK: bool = false
@export var LAUNCH_FIRST_SAVE: bool = false
@export var AUTO_ENABLE_DEBUG_UI: bool = false

@export_category("Constants")
@export var MAX_MESSAGE_SIZE: int = 5
@export var GRAVITY_MULTIPLIER := 3.5
@export var MOVEMENT_SPEED: float = 12.0
@export var ROTATION_SPEED := 10.0

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * GRAVITY_MULTIPLIER

var launch = true

func _ready() -> void:
	var dir := DirAccess.open(gesture_resources_path)
	if dir == null: 
		printerr("Could not open folder"); 
		return
		
	dir.list_dir_begin()
	for file: String in dir.get_files():
		var resource := load(dir.get_current_dir() + "/" + file)
		all_gestures.append(resource)
	

func end_game():
	get_tree().change_scene_to_file("res://Scenes/UI/EndScreen.tscn")


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Saves.save()
		get_tree().quit()
