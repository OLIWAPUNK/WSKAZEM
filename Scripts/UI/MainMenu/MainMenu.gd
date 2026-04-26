extends Control

@onready var delete_button: Button = %DeleteButton
@onready var play_button: Button = %PlayButton
@onready var about_button: Button = %AboutButton
@onready var quit_button: Button = %QuitButton

@onready var side_panel_container: Control = %SidePanelContainer
@onready var logo_panel: Control = %SidePanelContainer/LogoPanel
@onready var about_panel: Control = %SidePanelContainer/AboutPanel
@onready var saves_panel: SavePanel = %SidePanelContainer/SavesPanel

@onready var version_label: Label = %VersionLabel

func _ready() -> void:
	play_button.connect("pressed", _on_play_pressed)
	about_button.connect("pressed", _on_about_pressed)
	quit_button.connect("pressed", _on_quit_pressed)

	delete_button.connect("pressed", _on_delete_pressed)

	saves_panel.connect("save_file_selected", _on_save_file_selected)
	saves_panel.connect("save_file_deleted", _on_save_file_deleted)

	version_label.text = ProjectSettings.get_setting("application/config/version")

	if Global.LAUNCH_FIRST_SAVE and Global.launch:
		Global.launch = false
		_on_save_file_selected.call_deferred(0)

func _change_to_panel(panel: Control) -> void:
	for child in side_panel_container.get_children():
		child.visible = false
	panel.visible = true

func _change_to_panel_if(pressed: bool, panel: Control) -> void:
	if not pressed:
		if panel == saves_panel:
			delete_button.disabled = true
			delete_button.text = ""
			delete_button.button_pressed = false
			saves_panel._is_deleting = false
		_change_to_panel(logo_panel)
	else:
		if panel == saves_panel and Saves.existing_saves.size() > 0:
			delete_button.disabled = false
			delete_button.text = "Delete a save..."
		else:
			delete_button.disabled = true
			delete_button.text = ""
			delete_button.button_pressed = false
			saves_panel._is_deleting = false
		_change_to_panel(panel)

func _on_delete_pressed():
	saves_panel._is_deleting = not saves_panel._is_deleting
	if saves_panel._is_deleting:
		delete_button.text = "Cancel delete"
	else:
		delete_button.text = "Delete a save..."

func _on_save_file_deleted() -> void:
	if Saves.existing_saves.size() == 0:
		delete_button.disabled = true
		delete_button.text = ""
		delete_button.button_pressed = false
		saves_panel._is_deleting = false

func _on_play_pressed():
	_change_to_panel_if(play_button.button_pressed, saves_panel)

func _on_about_pressed():
	_change_to_panel_if(about_button.button_pressed, about_panel)

func _on_quit_pressed():
	get_tree().quit()

var loading_screen: LoadingScreen

func _on_save_file_selected(save_file_index: int) -> void:
	loading_screen = LoadingScreen.load_scene("res://Scenes/GameWorld/World.tscn", false)
	loading_screen.connect("loading_finished", _on_loading_screen_finished)
	if not Saves.existing_saves.has(save_file_index):
		Saves.create_new(save_file_index)
		saves_panel.load_saves()
	Saves.load(save_file_index)
	loading_screen.start()

func _on_loading_screen_finished(scene: PackedScene) -> void:
	get_tree().root.add_child(scene.instantiate())
	queue_free()
	loading_screen.queue_free()
