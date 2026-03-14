@tool
class_name StateMachineEditor
extends EditorPlugin


const editor_scene_template = preload("res://addons/statemachineeditor/StateTreeGraph.tscn")

var editor_scene
var manager_script


func _enter_tree() -> void:

	editor_scene = editor_scene_template.instantiate()
	EditorInterface.get_editor_main_screen().add_child(editor_scene)
	_make_visible(false)
	

func _ready():

	manager_script = editor_scene.get_child(0)
	manager_script.setup_editor(":3", EditorInterface.get_edited_scene_root())

	scene_changed.connect(manager_script.update_edited_scene)
	main_screen_changed.connect(manager_script.update_workspace)


func _exit_tree() -> void:
	if editor_scene:
		editor_scene.queue_free()


func _make_visible(visible):
	if editor_scene:
		editor_scene.visible = visible


func _get_plugin_name() -> String:
	return "StateMachine"
	

func _has_main_screen() -> bool:
	return true


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
