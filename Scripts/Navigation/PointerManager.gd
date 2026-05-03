class_name PointerManager
extends Node

@onready var inventory_manager: InventoryManager = %InventoryUI/InventoryManager
@onready var gesture_manager: GestureMenuManager = %GameUI/TalkUI/CommunicationContainer/MarginContainer/VerticalContainer/GestureMenu/GestureMenuManager
@onready var navigation_manager : NavigationManager = %PlayerNode/NavigationManager

var hovered_object

var desired_distance: float = 0.1
var desired_interspace: float = 3


func _ready() -> void:
	assert(navigation_manager, "Navigation manager not found")
	assert(gesture_manager, "Gesture manager not found")

	Global.pointer_manager = self


func _unhandled_input(_event: InputEvent) -> void:

	if Global.player_controls_disabled:
		return

	if Input.is_action_just_released("mouse_interact"):
		if hovered_object:
			if hovered_object is AutoTravelZone:
				navigation_manager.go_to_point(hovered_object.travel_point.global_position)
			else:
				object_clicked(hovered_object as CanBeClicked)
		else:
			if Global.ui_manager.is_visible():
				Global.ui_manager.gesture_menu_manager.stop_talking()
				gesture_manager.clear_message()
			else:
				navigation_manager.navigate()

		get_viewport().set_input_as_handled()


func object_clicked(object: CanBeClicked):

	object.on_unhover()

	var last_target_desired_distance = navigation_manager.navigation_agent.target_desired_distance
	var target = object.parent.global_position
	if object.standing_point:
		target = object.standing_point.global_position
	else:
		navigation_manager.navigation_agent.target_desired_distance = desired_interspace

	await navigation_manager.go_to_point(target)

	navigation_manager.navigation_agent.target_desired_distance = last_target_desired_distance
	
	var player_pos = Global.player.global_transform.origin
	var object_pos = object.parent.global_transform.origin
	var direction = (object_pos - player_pos).normalized()
	$"%PlayerNode/PlayerMovement".target_rotation.y = atan2(direction.x, direction.z)

	if object is CanBeTalkedTo:
		gesture_manager.start_talking_with(object)
	elif object is CanBeGrabbed:
		inventory_manager.grab(object)
	elif object is CanBeModified:
		object.apply(inventory_manager.held_item.identifier)


func on_hover(node) -> void:

	hovered_object = node


func on_unhover(node) -> void:

	if node == hovered_object:
		hovered_object = null

func _physics_process(_delta: float) -> void:
	Global.debug.add_debug_property("Mouse pos", get_viewport().get_mouse_position(), 1)
	Global.debug.add_debug_property("Hovered object", hovered_object, 1)
