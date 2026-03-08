class_name OptionSetting
extends Setting

@export var options: Array[String]

func _ready() -> void:
	super._ready()
	var current_index = _get_current_index()

	var option_menu = setting_control as OptionButton
	option_menu.clear()
	for option in options:
		option_menu.add_item(str(option))
	option_menu.selected = current_index
	option_menu.connect("item_selected", _on_item_selected)

func _get_current_index() -> int:
	var current_value = get_current_value() as String
	var current_index = options.find(current_value)
	if current_index == -1:
		push_error("Current value '%s' for setting '%s/%s' is not a valid option." % [str(current_value), category, setting])
		return 0
	return current_index

func _on_item_selected(index: int) -> void:
	var option_key = options[index]
	emit_setting_updated(option_key)

func refresh() -> void:
	var option_menu = setting_control as OptionButton
	option_menu.selected = _get_current_index()
