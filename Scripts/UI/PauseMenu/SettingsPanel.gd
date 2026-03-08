class_name SettingsPanel
extends Control

@onready var video_button: Button = %VideoButton
@onready var audio_button: Button = %AudioButton
@onready var accessibility_button: Button = %AccessibilityButton

@onready var reset_button: Button = %ResetButton
@onready var confirmation_dialog: ConfirmationDialog = %ResetButton/ConfirmationDialog

@onready var side_panel_container: Control = %SidePanelContainer
@onready var video_panel: Control = %SidePanelContainer/VideoPanel
@onready var audio_panel: Control = %SidePanelContainer/AudioPanel
@onready var accessibility_panel: Control = %SidePanelContainer/AccessibilityPanel

func _ready() -> void:
	video_button.connect("pressed", _on_video_pressed)
	video_button.button_pressed = true

	audio_button.connect("pressed", _on_audio_pressed)
	accessibility_button.connect("pressed", _on_accessibility_pressed)

	reset_button.connect("pressed", confirmation_dialog.popup_centered)
	confirmation_dialog.connect("confirmed", _on_reset_confirmed)

	var category_to_panel: Dictionary = {
		"video": video_panel,
		"audio": audio_panel,
		"accessibility": accessibility_panel,
	}

	for category in category_to_panel.keys():
		var panel = category_to_panel[category].get_node("MarginContainer/VBoxContainer")
		var settings = Settings.get_category_settings(category)
		for setting in settings.keys():
			var value = settings[setting]

			var hbox = HBoxContainer.new()
			hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			hbox.add_theme_constant_override("separation", 16)

			var setting_label = Label.new()
			setting_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			setting_label.text = setting.capitalize().replace("_", " ")
			hbox.add_child(setting_label)

			if typeof(value) == TYPE_STRING:

				var enum_options = Settings.get_enum_options(category, setting)
				if enum_options.size() == 0:
					push_error("String setting '%s/%s' does not have enum options defined." % [category, setting])
					continue
				
				var control = OptionButton.new()
				for option in enum_options:
					control.add_item(str(option))
				control.selected = enum_options.find(value)

				control.connect("item_selected", func(index: int) -> void:
					_on_setting_changed(category, setting, enum_options[index])
				)

				hbox.add_child(control)

			elif typeof(value) == TYPE_BOOL:

				var control = CheckButton.new()
				control.button_pressed = value

				control.connect("pressed", func() -> void:
					_on_setting_changed(category, setting, control.button_pressed)
				)

				hbox.add_child(control)

			elif typeof(value) == TYPE_FLOAT:

				var label = Label.new()
				label.text = str(value)
				hbox.add_child(label)

				var control = HSlider.new()
				control.min_value = 0.0
				control.max_value = 1.0
				control.step = 0.05
				control.tick_count = 5
				control.ticks_on_borders = true
				control.value = value
				control.size_flags_horizontal = Control.SIZE_EXPAND_FILL

				control.connect("drag_ended", func(value_changed: bool) -> void:
					if value_changed:
						_on_setting_changed(category, setting, control.value)
				)
				control.connect("value_changed", func(value_changed: float) -> void:
					label.text = str(snapped(value_changed, control.step))
				)

				hbox.add_child(control)

			panel.add_child(hbox)

# TODO: Instead of simply updating the setting, bring the player to a interactive preview screen
func _on_setting_changed(category: String, setting: String, value: Variant) -> void:
	print("Setting changed: %s/%s = %s" % [category, setting, str(value)])
	Settings.set_setting(category, setting, value)

func _change_to_panel(panel: Control) -> void:
	for child in side_panel_container.get_children():
		child.visible = false
	panel.visible = true

func _on_video_pressed():
	_change_to_panel(video_panel)

func _on_audio_pressed():
	_change_to_panel(audio_panel)

func _on_accessibility_pressed():
	_change_to_panel(accessibility_panel)

func _on_reset_confirmed():
	Settings.reset_settings()
