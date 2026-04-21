class_name SettingsPanel
extends Control

@onready var side_panel_container: Control = %SidePanelContainer

@onready var video_button: Button = %VideoButton
@onready var audio_button: Button = %AudioButton
@onready var accessibility_button: Button = %AccessibilityButton

@onready var video_panel: Control = %SidePanelContainer/VideoPanel
@onready var audio_panel: Control = %SidePanelContainer/AudioPanel
@onready var accessibility_panel: Control = %SidePanelContainer/AccessibilityPanel

@onready var panels: Array = [video_panel, audio_panel, accessibility_panel]

@onready var reset_button: Button = %ResetButton
@onready var confirmation_dialog: ConfirmationDialog = %ResetButton/ConfirmationDialog

func _ready() -> void:
	video_button.connect("pressed", _on_video_pressed)
	video_button.button_pressed = true

	audio_button.connect("pressed", _on_audio_pressed)
	accessibility_button.connect("pressed", _on_accessibility_pressed)

	reset_button.connect("pressed", confirmation_dialog.popup_centered)
	confirmation_dialog.connect("confirmed", _on_reset_confirmed)

	for panel in panels:
		var settings_container = panel.get_node("MarginContainer/VBoxContainer")
		for child in settings_container.get_children():
			if child is Setting:
				child.setting_updated.connect(_on_setting_updated)

# TODO: Instead of simply updating the setting, bring the player to a interactive preview screen
func _on_setting_updated(category: String, setting: String, value: Variant) -> void:
	Settings.set_setting(category, setting, value)

func _on_reset_confirmed():
	Settings.reset_settings()

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
