class_name Debug extends Control

var props: Array

@onready var container = $PanelContainer/VBoxContainer

func _ready() -> void:
	Global.debug = self
	visible = false
	
func _input(event: InputEvent):
	if event.is_action_pressed("debug"):
		visible = not visible
		get_viewport().set_input_as_handled()

func add_debug_property(id: StringName, value, update_every_frames: int):
	if not visible:
		return

	if props.has(id):
		@warning_ignore("integer_division")
		if Time.get_ticks_msec() / 16 % update_every_frames == 0:
			var target = container.find_child(id, true, false) as Label
			target.text = id + ": " + str(value)
	else:
		var prop = Label.new()
		prop.name = id
		prop.text = id + ": " + str(value)
		prop.add_theme_font_size_override("font_size", 10)
		props.append(id)
		container.add_child(prop)
		
