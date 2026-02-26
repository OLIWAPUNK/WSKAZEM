extends Control

@onready var play_button: Button = %PlayButton
@onready var about_button: Button = %AboutButton
@onready var quit_button: Button = %QuitButton
@onready var side_panel_container: Control = %SidePanelContainer

func _ready() -> void:
	play_button.button_pressed = true
	play_button.connect("pressed", _on_play_pressed)
	about_button.connect("pressed", _on_about_pressed)
	quit_button.connect("pressed", _on_quit_pressed)

func _on_play_pressed():
	about_button.button_pressed = false
	get_tree().change_scene_to_file("res://Scenes/GameWorld/World.tscn")

func _on_about_pressed():
	play_button.button_pressed = false
	pass

func _on_quit_pressed():
	get_tree().quit()
