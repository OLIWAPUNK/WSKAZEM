class_name GestureMenuManager
extends Node

@export var gesture_list: Array[GestureData]

var gesture_tile = preload("res://Scenes/UI/Communication/GestureTile.tscn")

@onready var menu_container: VBoxContainer = $"../ColumnContainer"

var menu_rows: Array[HBoxContainer]
var row_capacity: int = 3
var last_row_count = 0

var message_tile = preload("res://Scenes/UI/Communication/MessageTile.tscn")

@onready var message_container: HBoxContainer = $"../../MessageQueueContainer/MarginContainer/MessageQueue"

var message: Array[GestureData] = []
var current_reciever: CanBeTalkedTo

@onready var clear_button: Button = %ClearButton
@onready var play_button: Button = %PlayButton

func _ready() -> void:
	assert(gesture_tile, "Gesture tile not loaded")
	assert(message_tile, "Message tile not loaded")
	assert(menu_container, "Menu container not found")
	assert(message_container, "Message container not found")

	if not is_in_group("GameEvents"):
		add_to_group("GameEvents")

	var data = Saves.get_data_or_null("learned_gestures")
	if data:
		data = data as Array[String]
		for path in data:
			if not ResourceLoader.exists(path):
				push_error("Gesture file not found: " + path)
				continue
			var gesture = load(path)
			if gesture is not GestureData:
				push_error("Resource at path %s is not a GestureData!" % path)
				continue
			if gesture not in gesture_list:
				gesture_list.append(gesture)
	fill_gesture_menu(gesture_list)

	clear_button.connect("pressed", clear_message)
	play_button.connect("pressed", send_message)

func toggle_play_button(enabled: bool) -> void:
	play_button.disabled = not enabled
	# GRAYOUT gesty

func start_talking_with(object: CanBeTalkedTo) -> void:
	Global.ui_manager.set_visible(true)
	Global.game_viewport_container.anchor_left = 0.5
	if object.can_focus():
		Global.camera_zone_manager.focus(object.get_focus_position())
	current_reciever = object
	object.start_talking()

func stop_talking() -> void:
	Global.ui_manager.set_visible(false)
	Global.game_viewport_container.anchor_left = 0.0
	if current_reciever.can_focus():
		Global.camera_zone_manager.unfocus()
	current_reciever = null
	


func send_message() -> void:
	current_reciever.tell(message.duplicate())
	clear_message()


func fill_gesture_menu(availible_gesture_list: Array[GestureData]) -> void:
	reset_menu_container()

	for gesture in availible_gesture_list:
		add_gesture_tile(generate_gesture_tile(gesture))


func reset_menu_container() -> void:
	menu_rows = []

	for child in menu_container.get_children():
		child.queue_free()

	add_row()


func gesture_pressed(gesture: GestureData) -> void:
	if play_button.disabled:
		return
	add_message_tile(gesture, message.size())


func message_pressed(index: int) -> void:
	# USUWANIE
	print_debug(index)


func clear_message() -> void:
	message = []

	for child in message_container.get_children():
		child.queue_free()


func generate_message_tile(gesture: GestureData, index: int) -> Control:

	var new_tile = message_tile.instantiate()

	var new_tile_button = new_tile.get_node("ButtonContainer/Gesture")

	new_tile_button.texture_normal = gesture.display_normal
	new_tile_button.texture_hover = gesture.display_hover
	new_tile_button.texture_pressed = gesture.display_pressed

	new_tile_button.connect("pressed", func(): message_pressed(index))

	return new_tile


func generate_gesture_tile(gesture: GestureData) -> Control:

	var new_tile = gesture_tile.instantiate()

	var new_tile_button = new_tile.get_node("ButtonContainer/Gesture")

	new_tile_button.texture_normal = gesture.display_normal
	new_tile_button.texture_hover = gesture.display_hover
	new_tile_button.texture_pressed = gesture.display_pressed

	new_tile_button.connect("pressed", gesture.pressed)
	gesture.connect("gesture_pressed", gesture_pressed)

	return new_tile


func add_message_tile(gesture: GestureData, at_index: int) -> void:

	message.append(gesture)
	message_container.add_child.call_deferred(generate_message_tile(gesture, at_index))


func add_gesture_tile(new_tile: Control) -> void:

	if last_row_count >= row_capacity:
		add_row()

	menu_rows.back().add_child.call_deferred(new_tile)
	last_row_count += 1


func add_row() -> void:

	var new_row = HBoxContainer.new()
	new_row.custom_minimum_size = Vector2(0, 100)

	menu_rows.append(new_row)
	menu_container.add_child.call_deferred(new_row)

	last_row_count = 0


func add_gesture(new_gesture: GestureData) -> void:

	if new_gesture in gesture_list:
		return

	gesture_list.append(new_gesture)
	add_gesture_tile(generate_gesture_tile(new_gesture))

func on_save():
	Saves.set_data("learned_gestures", gesture_list.map(func (g: GestureData): return g.resource_path))
