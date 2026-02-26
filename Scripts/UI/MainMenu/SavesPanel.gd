class_name SavePanel
extends Control

signal save_file_selected(save_file_index: int)

@onready var save_file_container: HBoxContainer = %SaveFileContainer

const SAVE_FILE_SCENE: PackedScene = preload("res://Scenes/UI/MainMenu/SaveFile.tscn")

var saves = [
	{
		"main_progress": 66.0,
		"extra_progress": 5.0,
		"time": "01 : 23 : 45",
	},
	{
		"main_progress": 33.0,
		"extra_progress": 0.0,
		"time": "00 : 45 : 12",
	}
]

func _ready() -> void:
	for i in range(3):
		var save_file = SAVE_FILE_SCENE.instantiate()
		if i < saves.size():
			save_file.save_file_index = i
			save_file.main_progress = saves[i]["main_progress"]
			save_file.extra_progress = saves[i]["extra_progress"]
			save_file.time = saves[i]["time"]
			save_file.connect("save_file_selected", func(index): save_file_selected.emit(index))
		save_file_container.add_child(save_file)