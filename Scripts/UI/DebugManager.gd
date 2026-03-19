class_name Debug
extends Node

var props: Array

@onready var debug_ui: Control = $".."
@onready var container = $'../PanelContainer/VBoxContainer'

const debug_bitch = preload("res://Scenes/DEBUGBITCH.tscn")
var bitches: Dictionary[String, MeshInstance3D] = {}

func _ready() -> void:

	Global.debug = self
	debug_ui.visible = false

func _process(_delta: float) -> void:
	
	add_debug_property("FPS", Engine.get_frames_per_second(), 60)	

func _input(event: InputEvent):

	if event.is_action_pressed("debug"):

		debug_ui.visible = not debug_ui.visible
		get_viewport().set_input_as_handled()


func add_debug_property(id: StringName, value, update_every_frames: int):

	if not debug_ui.visible:
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
		

func remove_debug_property(id: StringName):

	if props.has(id):

		var target = container.find_child(id, true, false) as Label
		container.remove_child(target)
		target.queue_free()
		props.erase(id)


func move_bitch(target: Vector3, bitch_ball: String = "default") -> void:

	if not bitches.get(bitch_ball):
		bitches[bitch_ball] = debug_bitch.instantiate()
		$"/root/World".add_child(bitches[bitch_ball])
		
	bitches[bitch_ball].global_position = target
