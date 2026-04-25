@icon("res://assets/Textures/EditorIcons/AnimationPackage.svg")
class_name AnimationPackage
extends Node


func call_by_name(func_name: String) -> void:
	if has_method(func_name):
		call(func_name)
	else:
		push_error("No function named %s in %s" % [func_name, self])