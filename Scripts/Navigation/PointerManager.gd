extends Node

@onready var navigation_manager : NavigationManager = %PlayerNode/NavigationManager
var hovered_object : Clickable

var desired_distance: float = 0.1
var desired_interspace: float = 3

@onready var gesture_manager: GestureMenuManager = %GameUI/CommunicationContainer/MarginContainer/VerticalContainer/GestureMenu/GestureMenuManager



func _ready() -> void:
	assert(navigation_manager, "Navigation manager not found")
	assert(gesture_manager, "Gesture manager not found")


func _unhandled_input(_event: InputEvent) -> void:

	if Global.player_controls_disabled:
		return

	if Input.is_action_just_pressed("mouse_interact"):


		if hovered_object:
			object_clicked(hovered_object)
		else:
			%GameUI/CommunicationContainer.visible = false
			gesture_manager.clear_message()
			navigation_manager.navigate()

		get_viewport().set_input_as_handled()


func object_clicked(object: Clickable):

	if object.standing_point:
		navigation_manager.go_to_point(object.standing_point.global_position)
	else:
		navigation_manager.navigation_agent.target_desired_distance = desired_interspace
		navigation_manager.go_to_point(object.parent.global_position)
	
	gesture_manager.start_talking_with(object)


func on_hover(node: Clickable) -> void:
	
	hovered_object = node


func on_unhover(node: Clickable) -> void:

	if node == hovered_object:
		hovered_object = null
