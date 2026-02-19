@tool
class_name StateMachineEditor
extends EditorPlugin


var panel_instance
var manager_script
const editor_scene = preload("res://addons/statemachineeditor/StateTreeGraph.tscn")


func _enter_tree() -> void:

	panel_instance = editor_scene.instantiate()
	EditorInterface.get_editor_main_screen().add_child(panel_instance)
	_make_visible(false)

	manager_script = panel_instance.get_child(0)
	manager_script.setup_graph(panel_instance)

	scene_changed.connect(manager_script.editor_scene_changed)
	main_screen_changed.connect(manager_script.screen_changed)


func _exit_tree() -> void:
	if panel_instance:
		panel_instance.queue_free()


func _make_visible(visible):
	if panel_instance:
		panel_instance.visible = visible


func _get_plugin_name() -> String:
	return "StateMachine"
	

func _has_main_screen() -> bool:
	return true


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")