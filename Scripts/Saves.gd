class_name SaveManger
extends Node

const SAVES_FOLDER_PATH: String = "user://saves/"

var existing_saves: Dictionary[int, Dictionary] = {}

var _current_save = null
var _current_save_index = -1

func _path(i: int):
    return SAVES_FOLDER_PATH + "save" + var_to_str(i) + ".json"

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

func load(index: int):
    if not existing_saves.has(index):
        push_warning("No save file with index: " + var_to_str(index))
    _current_save = existing_saves[index].duplicate()
    _current_save_index = index

func unload():
    _current_save = null
    _current_save_index = -1

func save():
    if _current_save == null:
        push_error("No save loaded")
        return
    _save_data(_current_save_index, _current_save)

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
        if current_depth.has(key):
            if i == keys.size() - 1:
                _current_save[key] = data
                return true
            else:
                current_depth = current_depth[key]
    return false

