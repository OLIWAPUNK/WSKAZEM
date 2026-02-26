class_name MapManager
extends Node

@onready var fade_transition: FadeTransition = %FadeTransition

var loading_screen : LoadingScreen = null
var current_scene : Node = null

func _ready() -> void:

	Global.map_manager = self

	fade_transition.fade_in()
	assert(get_child_count() < 2, "MapNode should have max 1 child")
	if get_child_count() == 0:
		go_to_scene("res://Scenes/GameWorld/Town.tscn")
	else:
		current_scene = get_child(0)


func go_to_scene(path : String) -> void:

	_deferred_goto_scene.call_deferred(path)


func _deferred_goto_scene(path: String):

	assert(ResourceLoader.exists(path), "Scene path does not exist: " + path)

	loading_screen = LoadingScreen.load_scene(path, get_tree().current_scene)
	loading_screen.connect("loading_finished", _on_loading_screen_finished)


func _on_loading_screen_finished(scene: PackedScene) -> void:

	await fade_transition.fade_out()
	if current_scene != null:
		current_scene.queue_free()
	current_scene = scene.instantiate()
	add_child(current_scene)
	
	loading_screen.queue_free()
	loading_screen = null
	fade_transition.fade_in()
