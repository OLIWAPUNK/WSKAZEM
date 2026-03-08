class_name CheckSetting
extends Setting

func _ready() -> void:
	super._ready()
	var check_button = setting_control as CheckButton
	check_button.button_pressed = get_current_value() as bool
	check_button.connect("pressed", _on_pressed)

func _on_pressed() -> void:
	emit_setting_updated((setting_control as CheckButton).button_pressed)

func refresh() -> void:
	var check_button = setting_control as CheckButton
	check_button.button_pressed = get_current_value() as bool
