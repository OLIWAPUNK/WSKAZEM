@icon("res://assets/Textures/EditorIcons/AnimationPackage.svg")
class_name AnimationPackage
extends Node


@export var cutscene_collection: CutsceneCollection


func call_by_name(func_name: String) -> void:
	if has_method(func_name):
		await call(func_name)
	else:
		push_error("No function named %s in %s" % [func_name, self])


func DEFAULT() -> void:
	print("debug! DEFAULT")