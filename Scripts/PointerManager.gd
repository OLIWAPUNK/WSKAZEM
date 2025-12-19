extends Node

@onready var navigation_manager : NavigationManager = %PlayerNode/NavigationManager
var hovered_object : Clickable

var desired_distance: float = 0.1
var desired_interspace: float = 3



func _unhandled_input(_event: InputEvent) -> void:

	if Input.is_action_just_pressed("mouse_interact"):

		if hovered_object:
			object_clicked(hovered_object)
		else:
			navigation_manager.navigate()

		get_viewport().set_input_as_handled()


func object_clicked(object: Clickable):

	if object.standing_point:
		navigation_manager.go_to_point(object.standing_point.global_position)
	else:
		navigation_manager.navigation_agent.target_desired_distance = desired_interspace
		navigation_manager.go_to_point(object.parent.global_position)


func on_hover(node: Clickable) -> void:
	
	hovered_object = node


func on_unhover(node: Clickable) -> void:

	if node == hovered_object:
		hovered_object = null
