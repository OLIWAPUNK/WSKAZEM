class_name SavePanel
extends Control

signal save_file_selected(save_file_index: int)

@onready var save_file_container: HBoxContainer = %SaveFileContainer

const SAVE_FILE_SCENE: PackedScene = preload("res://Scenes/UI/MainMenu/SaveFile.tscn")

func _ready() -> void:
	load_saves()

func load_saves() -> void:
	for child in save_file_container.get_children():
		child.queue_free()
	var saves = Saves.existing_saves
	for i in range(3):
		var save_file = SAVE_FILE_SCENE.instantiate()
		save_file.save_file_index = i
		if saves.has(i):
			save_file.main_progress = saves[i]["main_progress"]
			save_file.extra_progress = saves[i]["extra_progress"]
			save_file.time = saves[i]["time"]
			save_file.has_data = true
		save_file.connect("save_file_selected", func(index: int): save_file_selected.emit(index))
		save_file_container.add_child(save_file)
