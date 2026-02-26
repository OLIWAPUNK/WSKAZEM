class_name LoadingScreen
extends Control

signal loading_finished(scene: PackedScene)

@export var scene_to_load: String = "res://Scenes/GameWorld/World.tscn"
var progress = []

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = %ProgressBar

func _ready() -> void:
	anim_player.play("loading_text")
	ResourceLoader.load_threaded_request(scene_to_load)

func _process(_delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(scene_to_load, progress)
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		progress_bar.value = progress[0] * 100.0
	elif status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		set_process(false)
		progress_bar.value = 100.0
		var new_scene = ResourceLoader.load_threaded_get(scene_to_load)
		loading_finished.emit(new_scene)

static func load_scene(scene_path: String, parent: Node) -> LoadingScreen:
	var loading_screen = load("res://Scenes/UI/LoadingScreen.tscn").instantiate() as LoadingScreen
	loading_screen.scene_to_load = scene_path
	parent.add_child(loading_screen)
	return loading_screen
