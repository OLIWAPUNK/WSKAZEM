extends Control

@onready var resume_button: Button = %ResumeButton
@onready var save_and_quit_button: Button = %SaveAndQuitButton
@onready var back_panel: Panel = $BackPanel

var target_modulate: Color = Color(1, 1, 1, 1)
var back_panel_target_modulate: Color = Color(0, 0, 0, .5)

func _ready() -> void:

	visible = false
	back_panel.visible = true
	back_panel.modulate = back_panel_target_modulate

	resume_button.connect("mouse_entered", _on_resume_mouse_entered)
	resume_button.connect("mouse_exited", _on_resume_mouse_exited)
	resume_button.connect("pressed", _on_resume_pressed)

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

func _on_resume_mouse_exited():
	target_modulate = Color(1, 1, 1, 1)
	back_panel_target_modulate = Color(0, 0, 0, .5)

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

func _on_save_and_quit_mouse_exited():
	back_panel_target_modulate = Color(0, 0, 0, .5)

func _on_save_and_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")
