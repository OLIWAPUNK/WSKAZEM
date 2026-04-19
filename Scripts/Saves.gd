class_name SaveManger
extends Node

const SAVES_FOLDER_PATH: String = "user://saves/"

var existing_saves = {}

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

func create_new(index: int):
    var blank = _blank_save()
    _save(index, blank)
    existing_saves[index] = blank

func _save(index: int, data: Dictionary):
    var file = FileAccess.open(_path(index), FileAccess.WRITE)
    file.store_string(JSON.stringify(data))
    file.close()

    
func _blank_save():
    return {
        "main_progress": 0.0,
        "extra_progress": 0.0,
		"time": "00 : 00 : 00",
    }