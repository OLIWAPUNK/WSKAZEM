extends Node

const SAVES_FOLDER_PATH: String = "user://saves/"

var existing_saves: Dictionary[int, Dictionary] = {}

var _current_save = null
var _current_save_index = -1
var _load_time = 0


func _path(i: int):
	return SAVES_FOLDER_PATH + "save" + var_to_str(i)

func _init() -> void:
	if not DirAccess.dir_exists_absolute(SAVES_FOLDER_PATH):
		DirAccess.make_dir_absolute(SAVES_FOLDER_PATH)

	for i in range(3):
		var path = _path(i)
		if FileAccess.file_exists(path):
			var json = FileAccess.get_file_as_string(path)
			var dict = JSON.parse_string(json)
			if dict == null:
				push_error("Failed to JSON parse file: " + path)
				continue
			existing_saves[i] = dict

func delete_save(index: int):
	var path = _path(index)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
	existing_saves.erase(index)

func save():
	if _current_save == null:
		return

	_save_time_played()

	get_tree().call_group("GameEvents", "on_save")
	_save_data(_current_save_index, _current_save)

	_load_time = _get_current_seconds()

func load(index: int):
	if not existing_saves.has(index):
		push_error("No save file with index: " + var_to_str(index))
		return
	_current_save = existing_saves[index].duplicate()
	_current_save_index = index
	_load_time = _get_current_seconds()

func unload():
	existing_saves[_current_save_index] = _current_save.duplicate()
	_current_save = null
	_current_save_index = -1
	_load_time = 0


func get_data_or_null(path: String):
	if _current_save == null:
		push_error("No save loaded")
		return null
	var keys = path.split(".")
	var current_depth = _current_save
	for i in range(keys.size()):
		var key = keys[i]
		if current_depth.has(key):
			if i == keys.size() - 1:
				return current_depth[key]
			else:
				current_depth = current_depth[key]
	return null

func set_data(path: String, data) -> bool:
	if _current_save == null:
		push_error("No save loaded")
		return false
	var keys = path.split(".")
	var current_depth = _current_save
	for i in range(keys.size()):
		var key = keys[i]
		if i == keys.size() - 1:
			current_depth[key] = data
			return true
		else:
			if not current_depth.has(key):
				current_depth[key] = {}
			current_depth = current_depth[key]
	return false

func create_new(index: int):
	var blank = {
		"main_progress": 0.0,
		"extra_progress": 0.0,
		"time": "00 : 00 : 00",
	}
	_save_data(index, blank)
	existing_saves[index] = blank

func _save_data(index: int, data: Dictionary):
	var file = FileAccess.open(_path(index), FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func _save_time_played():
	var seconds_played = _get_current_seconds() - _load_time
	
	var saved = get_data_or_null("time").split(" : ")
	var seconds_saved = int(saved[0]) * 60 * 60 + int(saved[1]) * 60 + int(saved[2])

	var seconds_total = seconds_saved + seconds_played

	var seconds = seconds_total % 60
	var minutes = int(seconds_total / 60.0) % 60
	var hours = int(seconds_total / 60.0 / 60.0)
	set_data("time", "%02d : %02d : %02d" % [hours, minutes, seconds])


func _get_current_seconds() -> int:
	return int(Time.get_ticks_msec() / 1000.0)
