extends Node


static var debug : Debug
static var map_manager : MapManager
static var cutscene_manager : CutsceneManager
static var player_controls_disabled : bool = false

@export var overlay_outline_material : ShaderMaterial


func _ready() -> void:

	assert(overlay_outline_material, "No overlay outline material set")


func _process(_delta: float) -> void:
	
	debug.add_debug_property("FPS", Engine.get_frames_per_second(), 60)
	debug.add_debug_property("Mouse pos", get_viewport().get_mouse_position(), 1)

static func go_to_scene(path : String) -> void:

	map_manager.go_to_scene(path)

static func play_cutscene(cutscene_name: String) -> Signal:
	
	return cutscene_manager.play_cutscene(cutscene_name)
