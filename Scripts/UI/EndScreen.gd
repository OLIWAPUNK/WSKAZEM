class_name EndGame
extends Control

@onready var return_button: Button = %ReturnButton

func _ready() -> void:
	return_button.connect("pressed", _return_pressed)

func _return_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/MainMenu.tscn")