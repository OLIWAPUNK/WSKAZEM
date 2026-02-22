class_name PointerManager
extends Node

@onready var inventory_manager: InventoryManager = %InventoryManager
@onready var gesture_manager: GestureMenuManager = %GameUI/CommunicationContainer/MarginContainer/VerticalContainer/GestureMenu/GestureMenuManager
@onready var navigation_manager : NavigationManager = %PlayerNode/NavigationManager

var hovered_object : CanBeClicked

var desired_distance: float = 0.1
var desired_interspace: float = 3

var hold_mouse_movements = false
var held_frame_counter = 0


func _ready() -> void:
	assert(navigation_manager, "Navigation manager not found")
	assert(gesture_manager, "Gesture manager not found")

	Global.pointer_manager = self


func _unhandled_input(_event: InputEvent) -> void:

	if Global.player_controls_disabled:
		return

	if Input.is_action_just_released("mouse_interact"):
		held_frame_counter = 0
		if not hold_mouse_movements:
			if hovered_object:
				object_clicked(hovered_object)
			else:
				if Global.ui_manager.is_visible():
					Global.ui_manager.set_visible(false)
					gesture_manager.clear_message()
				else:
					navigation_manager.navigate()
		else:
			hold_mouse_movements = false

		get_viewport().set_input_as_handled()
	elif Input.is_action_pressed("mouse_interact"):
		held_frame_counter += 1
		if held_frame_counter > 10:
			hold_mouse_movements = true


func object_clicked(object: CanBeClicked):

	object.on_unhover()

	var target = object.parent.global_position
	if object.standing_point:
		target = object.standing_point.global_position
	else:
		navigation_manager.navigation_agent.target_desired_distance = desired_interspace
	await navigation_manager.go_to_point(target)
	
	if object is CanBeTalkedTo:
		gesture_manager.start_talking_with(object)
	elif object is CanBeGrabbed:
		inventory_manager.grab(object)


func on_hover(node: CanBeClicked) -> void:

	hovered_object = node


func on_unhover(node: CanBeClicked) -> void:

	if node == hovered_object:
		hovered_object = null

func _physics_process(_delta: float) -> void:
	Global.debug.add_debug_property("Mouse hold mode", hold_mouse_movements, 1)
	Global.debug.add_debug_property("Hovered object", hovered_object, 1)
