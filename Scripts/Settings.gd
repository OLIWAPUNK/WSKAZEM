extends Node

const SETTINGS_FILE_PATH: String = "user://settings.cfg"

var _default_settings: Dictionary = {
	"video": {
		"resolution": Vector2i(1280, 720),
		"fullscreen": false,
	},
	"audio": {
		"master_volume": 0.5,
		"music_volume": 0.5,
		"sfx_volume": 0.5,
	},
	"accessibility": {},
}

var _settings: Dictionary = _default_settings.duplicate(true)

func _ready() -> void:
	if not FileAccess.file_exists(SETTINGS_FILE_PATH):
		_save_settings()
	else:
		_load_settings()

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
	if _settings.has(category) and _settings[category].has(setting):
		return _settings[category][setting]
	return null

func set_setting(category: String, setting: String, value: Variant) -> void:
	if _settings.has(category) and _settings[category].has(setting):
		_settings[category][setting] = value
		_save_settings()
	else:
		push_error("Attempted to set invalid setting: %s/%s" % [category, setting])

func reset_settings() -> void:
	_settings = _default_settings.duplicate(true)
	_save_settings()

func compare_settings(other_settings: Dictionary) -> bool:
	for category in _settings.keys():
		if not other_settings.has(category):
			return false
		for setting in _settings[category].keys():
			if not other_settings[category].has(setting):
				return false
			if _settings[category][setting] != other_settings[category][setting]:
				return false
	return true
