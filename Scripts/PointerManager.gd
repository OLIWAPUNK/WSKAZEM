extends Node

@onready var navigation_manager : NavigationManager = %PlayerNode/NavigationManager
var hovered_object : Clickable



func _unhandled_input(_event: InputEvent) -> void:

	if Input.is_action_just_pressed("mouse_interact"):

		if hovered_object:
			print(hovered_object)
		else:
			navigation_manager.navigate()

		get_viewport().set_input_as_handled()


func on_hover(node: Clickable) -> void:
	
	hovered_object = node


func on_unhover(node: Clickable) -> void:

	if node == hovered_object:
		hovered_object = null
