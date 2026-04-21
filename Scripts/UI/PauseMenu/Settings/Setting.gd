class_name Setting
extends HBoxContainer

signal setting_updated(category: String, setting: String, value: Variant)

@export var category: String
@export var setting: String

@onready var setting_label: Label = $SettingLabel
@onready var setting_control: Control = $SettingControl

func _ready() -> void: 
	setting_label.text = setting.capitalize().replace("_", " ")
	Settings.connect("setting_changed", _on_setting_changed)

func emit_setting_updated(value: Variant) -> void: 
	setting_updated.emit(category, setting, value)

func get_current_value() -> Variant:
	return Settings.get_setting(category, setting)

func get_default_value() -> Variant:
	return Settings.get_default_value(category, setting)

func _on_setting_changed(_category: String, _setting: String, _value: Variant) -> void:
	if _category == category and _setting == setting:
		refresh()

func refresh() -> void:
	push_error("Unimplemented refresh method for setting: %s/%s" % [category, setting])
