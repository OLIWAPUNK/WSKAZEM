class_name LoadingScreen
extends Control

signal loading_finished(scene: PackedScene)

var _scene_to_load: String 
var _progress = []
var _auto_start: bool

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = %ProgressBar

func _ready() -> void:
	anim_player.play("loading_text")
	if _auto_start:
		start()

func _process(_delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(_scene_to_load, _progress)
	progress_bar.value = _progress[0] * 100.0
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		set_process(false)
		await get_tree().create_timer(0.01).timeout
		var new_scene = ResourceLoader.load_threaded_get(_scene_to_load)
		loading_finished.emit(new_scene)
		Global.is_loading = false

func start():
	Global.is_loading = true
	ResourceLoader.load_threaded_request(_scene_to_load)

static func load_scene(scene_path: String, auto_start: bool = true) -> LoadingScreen:
	var loading_screen = load("res://Scenes/UI/LoadingScreen.tscn").instantiate() as LoadingScreen
	loading_screen._scene_to_load = scene_path
	loading_screen._auto_start = auto_start
	Engine.get_main_loop().root.add_child(loading_screen)
	return loading_screen
