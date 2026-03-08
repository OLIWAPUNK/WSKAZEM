extends Node

signal setting_changed(category: String, setting: String, value: Variant)

const SETTINGS_FILE_PATH: String = "user://settings.cfg"

var _setting_meta = {
	"video": {
		"resolution": {
			"apply": _set_resolution,
			"default": "1280x720",
		},
		"fullscreen": {
			"apply": _set_fullscreen,
			"default": false,
		},
	},
	"audio": {
		"master_volume": {
			"range": Vector2(0, 1),
			"default": 0.5,
		},
		"music_volume": {
			"range": Vector2(0, 1),
			"default": 0.5,
		},
		"sfx_volume": {
			"range": Vector2(0, 1),
			"default": 0.5,
		},
	}
}

var _default_settings: Dictionary = (func () -> Dictionary:
	var defaults = {}
	for category in _setting_meta.keys():
		defaults[category] = {}
		for setting in _setting_meta[category].keys():
			var value = _setting_meta[category][setting].get("default", null)
			if value == null:
				push_error("No default value specified for setting: %s/%s" % [category, setting])
			defaults[category][setting] = value
	return defaults).call()

var _settings: Dictionary = _default_settings.duplicate(true)



func _ready() -> void:

	if not FileAccess.file_exists(SETTINGS_FILE_PATH):
		_save_settings()
	else:
		_load_settings()

	for category in _settings.keys():
		for setting in _settings[category].keys():
			var value = _settings[category][setting]
			var apply_func = get_setting_meta(category, setting, "apply")
			if apply_func != null:
				apply_func.call(value)

func _load_settings() -> void:

	var temp_settings = {}
	var config = ConfigFile.new()
	if config.load(SETTINGS_FILE_PATH) == OK:
		for category in _settings.keys():
			if not temp_settings.has(category):
				temp_settings[category] = {}
			for setting in _settings[category].keys():
				if config.has_section_key(category, setting):
					var value = config.get_value(category, setting)
					temp_settings[category][setting] = value

	var updated = false
	for category in _default_settings.keys():
		if not temp_settings.has(category) or typeof(temp_settings[category]) != TYPE_DICTIONARY:
			temp_settings[category] = _default_settings[category].duplicate(true)
			updated = true
		else:
			for setting in _default_settings[category].keys():
				if not temp_settings[category].has(setting) or typeof(temp_settings[category][setting]) != typeof(_default_settings[category][setting]):
					temp_settings[category][setting] = _default_settings[category][setting]
					updated = true
				else:
					var setting_range = get_setting_meta(category, setting, "range")
					if setting_range != null:
						var value = temp_settings[category][setting]
						temp_settings[category][setting] = clamp(value, setting_range.x, setting_range.y)
						if value != temp_settings[category][setting]:
							updated = true

	_settings = temp_settings
	if updated:
		_save_settings()

func _save_settings() -> void:

	var config = ConfigFile.new()
	for category in _settings.keys():
		for setting in _settings[category].keys():
			var value = _settings[category][setting]
			config.set_value(category, setting, value)
	config.save(SETTINGS_FILE_PATH)

func get_setting(category: String, setting: String) -> Variant:

	return _settings.get(category, {}).get(setting, null)

func set_setting(category: String, setting: String, value: Variant) -> void:

	if _settings.has(category) and _settings[category].has(setting):
		_settings[category][setting] = value
		_save_settings()
		setting_changed.emit(category, setting, value)
		var apply_func = get_setting_meta(category, setting, "apply")
		if apply_func != null:
			apply_func.call(value)
	else:
		push_error("Attempted to set invalid setting: %s/%s" % [category, setting])

func get_default_value(category: String, setting: String) -> Variant:

	return _default_settings.get(category, {}).get(setting, null)

func get_setting_meta(category: String, setting: String, meta_key: String) -> Variant:

	return _setting_meta.get(category, {}).get(setting, {}).get(meta_key, null)

func reset_settings() -> void:

	_settings = _default_settings.duplicate(true)
	_save_settings()




func _set_resolution(value: String) -> void:

	if _settings["video"]["fullscreen"]:
		set_setting("video", "fullscreen", false)
	var parts = value.split("x")
	get_window().size = Vector2i(parts[0].to_int(), parts[1].to_int())

func _set_fullscreen(value: bool) -> void:

	var mode = DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if value else DisplayServer.WindowMode.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)
