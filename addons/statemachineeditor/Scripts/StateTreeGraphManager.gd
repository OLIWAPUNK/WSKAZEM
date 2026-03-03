@tool
extends EditorPlugin

const gate_graphnode_template = preload("res://addons/statemachineeditor/Nodes/StateTreeGateNode.tscn")
const receiver_graphnode_template = preload("res://addons/statemachineeditor/Nodes/StateTreeReceiverNode.tscn")
const transmitter_graphnode_template = preload("res://addons/statemachineeditor/Nodes/StateTreeTransmitterNode.tscn")
const gate_node_template = preload("res://Resources/PuzzleElements/StateMachineTemplates/GateTemplate.tscn")

var state_machine_node: StateMachine
var graphedit_node: GraphEdit
var nameedit_node: LineEdit

var transmitters_select_node: MenuButton
var receivers_select_node: MenuButton

var editor_scene_root: Node

var transmitters: Array[GateTransmitter] = []
var transmitters_parents: Array[Node] = []
var receivers: Array[GateReceiver] = []
var receivers_parents: Array[Node] = []

var active: bool = false


func setup_graph(state_machine_scene) -> void:
	
	graphedit_node = state_machine_scene.get_node("PluginContainer/GraphContainer/GraphEdit")
	nameedit_node = state_machine_scene.get_node("PluginContainer/ButtonContainer/NameEdit")
	transmitters_select_node = state_machine_scene.get_node("PluginContainer/ButtonContainer/Transmitters")
	receivers_select_node = state_machine_scene.get_node("PluginContainer/ButtonContainer/Receivers")

	editor_scene_changed(EditorInterface.get_edited_scene_root())

	transmitters_select_node.get_popup().connect("id_pressed", add_new_transmitter_graphnode)
	receivers_select_node.get_popup().connect("id_pressed", add_new_receiver_graphnode)


func new_gate() -> void:
	
	if not graphedit_node or not nameedit_node:
		return

	if not state_machine_node:
		push_warning("No state machine in this tree")
		return

	var set_name: String = nameedit_node.text
	if not set_name:
		push_warning("Brak nazwy")
		return

	# sprawdzanie czy istnieje nazwa

	add_new_gate_with_graphnode(set_name)


func add_new_gate_with_graphnode(new_name: String) -> void:
		
	add_new_gate_graphnode(new_name)

	var new_gate_node: Gate = gate_node_template.instantiate()
	new_gate_node.name = new_name

	state_machine_node.add_child(new_gate_node)
	new_gate_node.owner = get_tree().edited_scene_root

	state_machine_node.gates[new_name] = new_gate_node

	EditorInterface.mark_scene_as_unsaved()


func add_new_gate_graphnode(new_name: String) -> GraphNode:
	
	var new_gate_graphnode: GraphNode = gate_graphnode_template.instantiate()
	new_gate_graphnode.title = new_name
	new_gate_graphnode.name = new_name

	graphedit_node.add_child(new_gate_graphnode)

	return new_gate_graphnode


func add_new_transmitter_graphnode(index: int) -> GraphNode:
	
	var new_transmitter_graphnode: GraphNode = transmitter_graphnode_template.instantiate()
	new_transmitter_graphnode.clear_all_slots()

	var transmitter_object := transmitters_parents[index]
	var transmitter_data := transmitters[index]

	new_transmitter_graphnode.title = transmitter_object.name
	new_transmitter_graphnode.get_node("Description").text = transmitter_data.node_description

	for output in transmitter_data.available_gates.size():

		var slot_label = Label.new()
		slot_label.text = str(output)
		slot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

		var slot_description = Label.new()
		slot_description.text = transmitter_data.descriptions[output]

		new_transmitter_graphnode.add_child(slot_label)
		new_transmitter_graphnode.add_child(slot_description)

		new_transmitter_graphnode.set_slot(2*output + 1, false, 0, Color.BLACK, true, 0, Color.WHITE)

	graphedit_node.add_child(new_transmitter_graphnode)

	return new_transmitter_graphnode


func add_new_receiver_graphnode(index: int) -> GraphNode:
	
	var new_receiver_graphnode: GraphNode = receiver_graphnode_template.instantiate()
	new_receiver_graphnode.title = receivers_parents[index].name
	new_receiver_graphnode.name = receivers_parents[index].name
	new_receiver_graphnode.get_node("Description").text = receivers[index].node_description

	graphedit_node.add_child(new_receiver_graphnode)

	return new_receiver_graphnode


func screen_changed(name: String) -> void:
	
	active = (name == "StateMachine")
	editor_scene_changed(null)


func editor_scene_changed(new_root: Node) -> void:

	if not active or not new_root:
		return
		
	for child in graphedit_node.get_children():
		if child is GraphNode:
			child.queue_free()

	editor_scene_root = new_root

	state_machine_node = null

	for child in new_root.get_children():
		if child is StateMachine:
			state_machine_node = child
			break

	if refresh_lists():
		load_graph()


func refresh_lists() -> bool:

	if not state_machine_node:
		push_warning("No StateMachine in scene")
		return false

	receivers = []
	receivers_parents = []
	receivers_select_node.get_popup().clear()
	transmitters = []
	transmitters_parents = []
	transmitters_select_node.get_popup().clear()
	
	for checked in get_all_nodes():
		for child in checked.get_children():

			if child is GateReceiver:
				receivers.append(child)
				receivers_parents.append(checked)
				receivers_select_node.get_popup().add_item(checked.name)
				break

			if child is GateTransmitter:
				transmitters.append(child)
				transmitters_parents.append(checked)
				transmitters_select_node.get_popup().add_item(checked.name)
				break

	return true


func get_all_nodes(start_node: Node = editor_scene_root, nodes_list: Array[Node] = []) -> Array[Node]:

	nodes_list.append(start_node)

	for child in start_node.get_children():
		get_all_nodes(child, nodes_list)

	return nodes_list


func load_graph() -> void:
	
	var temp_gates: Array[Gate] = []
	var temp_graphnodes: Array[GraphNode] = []

	for r_index in receivers_parents.size():

		var new_receiver_graphnode := add_new_receiver_graphnode(r_index)

	for gate_node: Gate in state_machine_node.get_children():

		var new_gate_graphnode := add_new_gate_graphnode(gate_node.name)
		
		temp_gates.append(gate_node)
		temp_graphnodes.append(new_gate_graphnode)

		for conn_receiver in gate_node.receivers:
			graphedit_node.connect_node(new_gate_graphnode.name, 0, conn_receiver.name, 0) # TO NIE DZIALA

	for t_index in transmitters_parents.size():

		var new_transmitter_graphnode := add_new_transmitter_graphnode(t_index)
		var available := transmitters[t_index].available_gates

		for t_conn_index in available.size():
			graphedit_node.connect_node(new_transmitter_graphnode.name, t_conn_index, available[t_conn_index], 0)






	graphedit_node.arrange_nodes()
		


func OLD_load_graph() -> void:

	var temp_gates: Array[Gate] = []
	var temp_graphnodes: Array[GraphNode] = []

	for gate_node: Gate in state_machine_node.get_children():

		var new_gate_graphnode := add_new_gate_graphnode(gate_node.name)

		temp_gates.append(gate_node)
		temp_graphnodes.append(new_gate_graphnode)

		for gate_transmitter in gate_node.transmitters:
			var index = transmitters.find(gate_transmitter.get_parent())

			var new_transmitter_graphnode := add_new_transmitter_graphnode(index)
			graphedit_node.connect_node(new_transmitter_graphnode.name, 0, new_gate_graphnode.name, 0)

		for gate_receiver in gate_node.receivers:
			var index = receivers.find(gate_receiver.get_parent())

			var new_receiver_graphnode := add_new_receiver_graphnode(index)
			graphedit_node.connect_node(new_gate_graphnode.name, 0, new_receiver_graphnode.name, 0)

	for gate_node in temp_gates:
		var to_gate := temp_graphnodes[temp_gates.find(gate_node)]

		for other_gate in gate_node.propagators:
			var from_gate := temp_graphnodes[temp_gates.find(other_gate)]

			graphedit_node.connect_node(from_gate.name, 0, to_gate.name, 0)


	graphedit_node.arrange_nodes()


