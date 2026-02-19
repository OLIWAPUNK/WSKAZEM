class_name MapManager
extends Node

var current_scene : Node = null

func _ready() -> void:
	Global.map_manager = self

	assert(get_child_count() < 2, "MapNode should have max 1 child")
	if get_child_count() == 0:
		go_to_scene("Scenes/GameWorld/Town.tscn")
	else:
		current_scene = get_child(0)

func go_to_scene(path : String) -> void:

	_deferred_goto_scene.call_deferred(path)

func _deferred_goto_scene(path):

	assert(ResourceLoader.exists(path), "Scene path does not exist: " + path)

	if current_scene != null:
		current_scene.free()
	current_scene = ResourceLoader.load(path).instantiate()
	add_child(current_scene)
	#TODO: Refresh all gate receivers
