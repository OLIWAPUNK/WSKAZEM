class_name SavePanel
extends Control

signal save_file_selected(save_file_index: int)
signal save_file_deleted()

@onready var save_files_container: HBoxContainer = %SaveFileContainer
@onready var confirm_delete: ConfirmationDialog = $ConfirmDelete

var _is_deleting = false

const SAVE_FILE_SCENE: PackedScene = preload("res://Scenes/UI/MainMenu/SaveFile.tscn")

func _ready() -> void:
	load_saves()

func load_saves() -> void:
	for child in save_files_container.get_children():
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
		save_file.connect("save_file_selected", _save_file_clicked)
		save_files_container.add_child(save_file)

func _save_file_clicked(save_file_index: int) -> void:
	if _is_deleting and Saves.existing_saves.has(save_file_index):
		confirm_delete.dialog_text = "Are you sure you want to delete save file %d?" % (save_file_index + 1)
		confirm_delete.popup_centered()
		confirm_delete.connect("confirmed", func(): _on_delete_confirmed(save_file_index))
	else:
		save_file_selected.emit(save_file_index)

func _on_delete_confirmed(save_file_index: int) -> void:
	Saves.delete_save(save_file_index)
	load_saves()
	save_file_deleted.emit()
