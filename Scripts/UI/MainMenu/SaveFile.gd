class_name SaveFile
extends Button

signal save_file_selected(save_file_index: int)

var save_file_index: int = -1
var main_progress: float = 0.0
var extra_progress: float = 0.0
var time: String = "-- : -- : --"
var has_data = false

@onready var main_progress_bar: TextureProgressBar = %MainProgressBar
@onready var extra_progress_bar: TextureProgressBar = %ExtraProgressBar
@onready var time_label: Label = $MarginContainer/Time
@onready var save_file_label: Label = $SaveFileText

func _ready() -> void:
	main_progress_bar.value = main_progress * 100.0
	extra_progress_bar.value = extra_progress * 100.0
	time_label.text = time
	if has_data:
		save_file_label.text = "Load Save File " + str(save_file_index + 1)
		main_progress_bar.visible = true
		if main_progress == 1.0:
			extra_progress_bar.visible = true
		else:
			extra_progress_bar.visible = false
	else:
		save_file_label.text = "Begin New Game"
		main_progress_bar.visible = false
		extra_progress_bar.visible = false

	connect("pressed", func(): save_file_selected.emit(save_file_index))	
	
