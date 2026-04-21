extends Control

@onready var resume_button: Button = %ResumeButton
@onready var settings_button: Button = %SettingsButton
@onready var save_and_quit_button: Button = %SaveAndQuitButton
@onready var back_panel: Panel = $BackPanel
@onready var settings_panel: SettingsPanel = %SettingsPanel

var target_modulate: Color = Color(1, 1, 1, 1)
var back_panel_target_modulate: Color = Color(0, 0, 0, .5)

func _ready() -> void:

	visible = false
	back_panel.visible = true
	back_panel.modulate = back_panel_target_modulate

	resume_button.connect("mouse_entered", _on_resume_mouse_entered)
	resume_button.connect("mouse_exited", _on_resume_mouse_exited)
	resume_button.connect("pressed", _on_resume_pressed)

	settings_button.button_pressed = true
	
	save_and_quit_button.connect("mouse_entered", _on_save_and_quit_mouse_entered)
	save_and_quit_button.connect("mouse_exited", _on_save_and_quit_mouse_exited)
	save_and_quit_button.connect("pressed", _on_save_and_quit_pressed)


func _process(delta: float) -> void:
	if modulate != target_modulate:
		modulate = lerp(modulate, target_modulate, delta * 5)
	if back_panel and back_panel.modulate != back_panel_target_modulate:
		back_panel.modulate = lerp(back_panel.modulate, back_panel_target_modulate, delta * 5)

func _on_resume_mouse_entered():
	target_modulate = Color(1, 1, 1, 0.5)
	back_panel_target_modulate = Color(0, 0, 0, 0)
	settings_button.button_pressed = false
	settings_panel.visible = false

func _on_resume_mouse_exited():
	target_modulate = Color(1, 1, 1, 1)
	back_panel_target_modulate = Color(0, 0, 0, .5)
	settings_button.button_pressed = true
	settings_panel.visible = true

func _on_resume_pressed():
	toggle()

func toggle():
	visible = not visible
	get_tree().paused = visible

func _unhandled_key_input(event: InputEvent) -> void:

	if event.is_action_pressed("pause"):

		toggle()
		get_viewport().set_input_as_handled()

func _on_save_and_quit_mouse_entered():
	back_panel_target_modulate = Color(0, 0, 0, 1)
	settings_button.button_pressed = false
	settings_panel.visible = false

func _on_save_and_quit_mouse_exited():
	back_panel_target_modulate = Color(0, 0, 0, .5)
	settings_button.button_pressed = true
	settings_panel.visible = true

var loading_screen: LoadingScreen

func _on_save_and_quit_pressed():
	get_tree().paused = false
	Saves.save()
	Saves.unload()
	loading_screen = LoadingScreen.load_scene("res://Scenes/UI/MainMenu/MainMenu.tscn", get_tree().root)
	loading_screen.connect("loading_finished", _on_loading_screen_finished)

func _on_loading_screen_finished(scene: PackedScene) -> void:
	get_tree().root.add_child(scene.instantiate())
	get_tree().root.get_node("World").queue_free()
	loading_screen.queue_free()