class_name SettingsPanel
extends Control

@onready var video_button: Button = %VideoButton
@onready var audio_button: Button = %AudioButton
@onready var accessibility_button: Button = %AccessibilityButton

@onready var side_panel_container: Control = %SidePanelContainer
@onready var video_panel: Control = %SidePanelContainer/VideoPanel
@onready var audio_panel: Control = %SidePanelContainer/AudioPanel

func _change_to_panel(panel: Control) -> void:
	for child in side_panel_container.get_children():
		child.visible = false
	panel.visible = true

func _ready() -> void:
	video_button.connect("pressed", _on_video_pressed)
	audio_button.connect("pressed", _on_audio_pressed)
	accessibility_button.connect("pressed", _on_accessibility_pressed)

func _on_video_pressed():
	_change_to_panel(video_panel)

func _on_audio_pressed():
	_change_to_panel(audio_panel)

func _on_accessibility_pressed():
	_change_to_panel(video_panel)