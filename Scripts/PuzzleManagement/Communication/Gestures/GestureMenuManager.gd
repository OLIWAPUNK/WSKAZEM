class_name GestureMenuManager
extends Node

@export var gesture_list: Array[GestureData]

@onready var menu_container: ItemList = $"../GestureContainer"
var message_tile = preload("res://Scenes/UI/Communication/MessageTile.tscn")

@onready var message_container: HBoxContainer = $"../../MessageQueueContainer/MarginContainer/MessageQueue"

var message: Array[GestureData] = []
var current_reciever: CanBeTalkedTo
var message_item_index: int = -1

@onready var clear_button: Button = %ClearButton
@onready var play_button: Button = %PlayButton


func _ready() -> void:
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
	menu_container.item_clicked.connect(item_pressed)
	menu_container.resized.connect(scale_items)

	clear_button.connect("pressed", clear_message)
	play_button.connect("pressed", send_message)


func toggle_play_button(enabled: bool) -> void:
	play_button.disabled = not enabled
	if enabled:
		play_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		menu_container.modulate = Color(1, 1, 1, 1)
	else:
		play_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
		menu_container.modulate = Color(.5, .5, .5, 1)


func start_talking_with(object: CanBeTalkedTo) -> void:
	Global.ui_manager.set_visible(true)
	Global.game_viewport_container.anchor_left = 0.5
	
	Global.camera_zone_manager.focus(object.focus_view)

	current_reciever = object
	object.start_talking()


func stop_talking() -> void:
	Global.ui_manager.set_visible(false)
	Global.game_viewport_container.anchor_left = 0.0

	Global.camera_zone_manager.unfocus()
	
	current_reciever = null
	

func send_message() -> void:
	current_reciever.tell(message.duplicate())
	clear_message()


func fill_gesture_menu(availible_gesture_list: Array[GestureData]) -> void:
	menu_container.clear()

	for gesture in availible_gesture_list:
		menu_container.add_item("", gesture.display_texture)


func item_pressed(index: int, _pos: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index != MOUSE_BUTTON_LEFT:
		return
	if play_button.disabled:
		return

	add_message_tile(gesture_list[index], message.size())


func message_pressed(index: int) -> void:

	var to_delete = message_container.get_child(index)
	message_container.remove_child(to_delete)
	to_delete.queue_free()
	message.pop_at(index)

	var all_tiles = message_container.get_children()
	for new_index in all_tiles.size():
		var button_node = all_tiles[new_index].get_node("ButtonContainer/Gesture")
		var method: Callable = button_node.pressed.get_connections()[0]["callable"]
		button_node.pressed.disconnect(method)
		button_node.pressed.connect(func(): message_pressed(new_index))


func clear_message() -> void:

	message = []
	for child in message_container.get_children():
		child.queue_free()


func add_message_tile(gesture: GestureData, at_index: int) -> void:

	if message.size() >= Global.MAX_MESSAGE_SIZE:
		return

	var new_tile = message_tile.instantiate()
	var new_tile_button = new_tile.get_node("ButtonContainer/Gesture")

	new_tile_button.texture_normal = gesture.display_texture
	new_tile_button.pressed.connect(func(): message_pressed(at_index))

	message.append(gesture)
	message_container.add_child.call_deferred(new_tile)


func add_gesture(new_gesture: GestureData) -> void:

	if new_gesture in gesture_list:
		return

	gesture_list.append(new_gesture)
	menu_container.add_item("", new_gesture.display_texture)


func scale_items():
	menu_container.icon_scale = (menu_container.size.x/3) / 610.0


func on_save():
	Saves.set_data("learned_gestures", gesture_list.map(func (g: GestureData): return g.resource_path))
