@icon("res://assets/Textures/EditorIcons/AnimationPackage.svg")
class_name AnimationPackage
extends Node


@export var cutscene_collection: CutsceneCollection
@export var looper: Array[String]


func _ready() -> void:
	assert(cutscene_collection, "No cutscene collection in %s" % self)
	for loop_method in looper:
		assert(has_method(loop_method), "No \"%s\" method int %s" % [loop_method, self])


func _call_by_name(func_name: String) -> void:
	if has_method(func_name):
		await call(func_name)
	else:
		push_error("No function named %s in %s" % [func_name, self])


func _add_looper(func_name: String):
	if has_method(func_name):
		if func_name in looper:
			push_warning("Function \"%s\" already in %s\'s looper" % [func_name, self])
			return
		looper.append(func_name)
	else:
		push_error("No function named %s in %s" % [func_name, self])


func _remove_looper(func_name: String):
	if func_name in looper:
		looper.erase(func_name)
	else:
		push_error("No function named %s in %s" % [func_name, self])


func _process(_delta: float) -> void:
	for loop_method in looper:
		call(loop_method)


func DEFAULT() -> void:
	print("debug! DEFAULT")