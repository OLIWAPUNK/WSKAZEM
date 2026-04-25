class_name MapManager
extends Node

signal scene_before_load

@onready var fade_transition: FadeTransition = %FadeTransition

var loading_screen : LoadingScreen = null
var current_scene : Node = null

func _ready() -> void:

	Global.map_manager = self

	fade_transition.fade_in()
	assert(get_child_count() < 2, "MapNode should have max 1 child")
	if get_child_count() != 0:
		current_scene = get_child(0)
		return
	var path = Saves.get_data_or_null("player.scene_path")
	if path != null and path != "":
		go_to_scene(path)
		return
	go_to_scene("res://Scenes/GameWorld/Alpha.tscn")

func get_current_scene_path() -> String:
	if current_scene == null:
		return ""
	return current_scene.scene_file_path

func on_save():
	Saves.set_data("player.scene_path", get_current_scene_path())

func go_to_scene(path : String) -> Signal:

	_deferred_goto_scene.call_deferred(path)

	return scene_before_load


func _deferred_goto_scene(path: String):

	assert(ResourceLoader.exists(path), "Scene path does not exist: " + path)

	loading_screen = LoadingScreen.load_scene(path)
	loading_screen.connect("loading_finished", _on_loading_screen_finished)


func _on_loading_screen_finished(scene: PackedScene) -> void:

	await fade_transition.fade_out()
	scene_before_load.emit()
	if current_scene != null:
		current_scene.queue_free()
	current_scene = scene.instantiate()
	add_child(current_scene)
	
	loading_screen.queue_free()
	loading_screen = null
	fade_transition.fade_in()
