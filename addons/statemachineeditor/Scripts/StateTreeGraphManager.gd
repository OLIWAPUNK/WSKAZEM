@tool
extends EditorPlugin

const gate_graphnode_template = preload("res://addons/statemachineeditor/Nodes/StateTreeGateNode.tscn")
const gate_node_template = preload("res://Resources/PuzzleElements/StateMachine/Gate.tscn")

var state_machine_node: StateMachine
var graphedit_node: GraphEdit
var nameedit_node: LineEdit

var editor_scene_root: Node


func _on_new_gate_button_pressed() -> void:
	
	if not graphedit_node or not nameedit_node:
		return

	if not state_machine_node:
		print("No state machine in this tree")
		return

	var set_name: String = nameedit_node.text
	if not set_name:
		print("Brak nazwy")
		return

	# sprawdzanie czy istnieje nazwa
		
	var new_gate_graphnode = gate_graphnode_template.instantiate()
	new_gate_graphnode.title = set_name

	graphedit_node.add_child(new_gate_graphnode)

	var new_gate_node: Gate = gate_node_template.instantiate()
	new_gate_node.name = set_name
	state_machine_node.add_child(new_gate_node)
	new_gate_node.owner = get_tree().edited_scene_root


func setup(state_machine_scene) -> void:
	
	graphedit_node = state_machine_scene.get_node("PluginContainer/GraphContainer/GraphEdit")
	nameedit_node = state_machine_scene.get_node("PluginContainer/ButtonContainer/NameEdit")

	# do zamiany jak znajde jak sie wyrzuca powiadomienia
	if not graphedit_node:
		print("NO GRAPHEDIT")
	if not nameedit_node:
		print("NO NAMEEDIT")

	editor_scene_root = EditorInterface.get_edited_scene_root()


func editor_scene_changed(new_root: Node) -> void:
	
	editor_scene_root = new_root

	var new_state_machine: StateMachine

	for child in new_root.get_children():
		if child is StateMachine:
			new_state_machine = child
			break

	if new_state_machine:
		state_machine_node = new_state_machine
