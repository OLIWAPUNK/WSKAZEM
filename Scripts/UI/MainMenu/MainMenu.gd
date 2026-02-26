extends Control

@onready var play_button: Button = %PlayButton
@onready var about_button: Button = %AboutButton
@onready var quit_button: Button = %QuitButton
@onready var side_panel_container: Control = %SidePanelContainer

const LOGO_PANEL_SCENE: PackedScene = preload("res://Scenes/UI/MainMenu/LogoPanel.tscn")
const SAVE_PANEL_SCENE: PackedScene = preload("res://Scenes/UI/MainMenu/SavesPanel.tscn")
const ABOUT_PANEL_SCENE: PackedScene = preload("res://Scenes/UI/MainMenu/AboutPanel.tscn")

func _ready() -> void:
	play_button.connect("pressed", _on_play_pressed)
	about_button.connect("pressed", _on_about_pressed)
	quit_button.connect("pressed", _on_quit_pressed)

	_change_panel(LOGO_PANEL_SCENE)

func _change_panel(panel_scene: PackedScene) -> void:
	for child in side_panel_container.get_children():
		child.queue_free()
	var panel = panel_scene.instantiate()
	side_panel_container.add_child(panel)

func _on_play_pressed():
	if not play_button.button_pressed:
		_change_panel(LOGO_PANEL_SCENE)
	else:
		about_button.button_pressed = false
		_change_panel(SAVE_PANEL_SCENE)

func _on_about_pressed():
	if not about_button.button_pressed:
		_change_panel(LOGO_PANEL_SCENE)
	else:
		play_button.button_pressed = false
		_change_panel(ABOUT_PANEL_SCENE)
func _on_quit_pressed():
	get_tree().quit()
