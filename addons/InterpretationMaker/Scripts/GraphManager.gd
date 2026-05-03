@tool
extends EditorPlugin

const thought_template = preload("res://addons/InterpretationMaker/Nodes/ThoughtNodeTemplate.tscn")
const behaviour_template = preload("res://addons/InterpretationMaker/Nodes/BehaviourNodeTemplate.tscn")
const reaction_template = preload("res://addons/InterpretationMaker/Nodes/ReactionNodeTemplate.tscn")
const start_template = preload("res://addons/InterpretationMaker/Nodes/StartNodeTemplate.tscn")
const state_template = preload("res://addons/InterpretationMaker/Nodes/StateNodeTemplate.tscn")

var thought_list: Array[GraphNode] = []
var behaviour_list: Array[GraphNode] = []
var reaction_list: Array[GraphNode] = []
var start_node: GraphNode
var state_list: Array[GraphNode] = []

var graphedit: GraphEdit

var scene_root: Node = null
var is_active: bool = false


func setup_editor(screen_name: String, root: Node) -> void:

	graphedit = get_parent().get_node("PluginContainer/GraphContainer/Inspector/GraphEdit")
	assert(graphedit, "No graphedit found")

	graphedit.add_valid_connection_type(0, 1)
	graphedit.add_valid_connection_type(0, 6)
	graphedit.add_valid_connection_type(2, 4)
	graphedit.add_valid_connection_type(3, 6)
	graphedit.add_valid_connection_type(5, 1)
	graphedit.add_valid_connection_type(5, 6)
	graphedit.add_valid_connection_type(5, 8)
	graphedit.add_valid_connection_type(7, 1)
	graphedit.add_valid_connection_type(7, 8)

	#graphedit.disconnection_request.connect(disconnect_nodes)
	#graphedit.connection_request.connect(connect_nodes)
	#graphedit.delete_nodes_request.connect(remove_node)
	#graphedit.node_selected.connect(selected_node)

	#name_input = get_parent().get_node("PluginContainer/ButtonContainer/NameEdit")

	get_parent().get_node("PluginContainer/ButtonContainer/NewThoughtButton").pressed.connect(new_thought)
	get_parent().get_node("PluginContainer/ButtonContainer/NewBehaviourButton").pressed.connect(new_behaviour)
	get_parent().get_node("PluginContainer/ButtonContainer/NewReactionButton").pressed.connect(new_reaction)
	get_parent().get_node("PluginContainer/ButtonContainer/NewStateButton").pressed.connect(new_state)
	
	# WLADUJ INTERPRETACJE

	if not start_node:
		start_node = start_template.instantiate()
		graphedit.add_child(start_node)

	update_workspace(screen_name)
	update_edited_scene(root)
	

func update_workspace(screen_name: String) -> void:
	is_active = screen_name == "Interpretations"
	refresh_editor()


func update_edited_scene(root: Node) -> void:
	scene_root = root
	refresh_editor()
	

func refresh_editor() -> void:
	pass
	
	
func new_thought() -> void:
	var new_node: GraphNode = thought_template.instantiate()
	graphedit.add_child(new_node)

	EditorInterface.mark_scene_as_unsaved()
	#state_machine_node.notify_property_list_changed()
	
	
func new_behaviour() -> void:
	var new_node: GraphNode = behaviour_template.instantiate()
	graphedit.add_child(new_node)

	EditorInterface.mark_scene_as_unsaved()
	#state_machine_node.notify_property_list_changed()
		
	
func new_reaction() -> void:
	var new_node: GraphNode = reaction_template.instantiate()
	graphedit.add_child(new_node)

	EditorInterface.mark_scene_as_unsaved()
	#state_machine_node.notify_property_list_changed()
	
	
func new_state() -> void:
	var new_node: GraphNode = state_template.instantiate()
	graphedit.add_child(new_node)

	EditorInterface.mark_scene_as_unsaved()
	#state_machine_node.notify_property_list_changed()
