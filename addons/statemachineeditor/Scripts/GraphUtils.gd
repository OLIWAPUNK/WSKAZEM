class_name GraphUtils
extends EditorPlugin


const gate_template = preload("res://addons/statemachineeditor/Nodes/StateTreeGateNode.tscn")
const receiver_template = preload("res://addons/statemachineeditor/Nodes/StateTreeReceiverNode.tscn")
const transmitter_template = preload("res://addons/statemachineeditor/Nodes/StateTreeTransmitterNode.tscn")


static func clean_graph(graph: GraphEdit) -> void:
	
	for child in graph.get_children():
		if child is GraphNode:
			child.queue_free()


static func get_all_nodes(start_node: Node, nodes_list: Array[Node] = []) -> Array[Node]:

	nodes_list.append(start_node)

	for child in start_node.get_children():
		get_all_nodes(child, nodes_list)

	return nodes_list


static func add_new_transmitter(graph: GraphEdit, transmitter_info: Dictionary) -> GraphNode:
	
	var new_transmitter: GraphNode = transmitter_template.instantiate()
	new_transmitter.clear_all_slots()

	var parent_node: Node = transmitter_info["Parent"]
	var child_node: GateTransmitter = transmitter_info["Child"]

	new_transmitter.title = parent_node.name
	new_transmitter.name = parent_node.name

	new_transmitter.get_node("Description").text = child_node.node_description

	for output in child_node.ports.size():

		var slot_label = Label.new()
		slot_label.text = str(output)
		slot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

		var slot_description = Label.new()
		slot_description.text = child_node.port_descriptions[output].description

		new_transmitter.add_child(slot_label)
		new_transmitter.add_child(slot_description)

		new_transmitter.set_slot(2*output + 1, false, 0, Color.BLACK, true, 0, Color.WHITE)

	graph.add_child(new_transmitter)

	return new_transmitter


static func add_new_receiver(graph: GraphEdit, receiver_info: Dictionary) -> GraphNode:
	
	var new_receiver: GraphNode = receiver_template.instantiate()

	new_receiver.title = receiver_info["Parent"].name
	new_receiver.name = receiver_info["Parent"].name

	new_receiver.get_node("Description").text = receiver_info["Child"].node_description

	graph.add_child(new_receiver)

	return new_receiver


static func add_new_gate(graph: GraphEdit, gate_info: Gate, choose_method: Callable) -> GraphNode:
	
	var new_gate: GraphNode = gate_template.instantiate()

	new_gate.title = gate_info.name
	new_gate.name = gate_info.name

	new_gate.get_node("TypeOptionButton").selected = gate_info.type
	new_gate.get_node("TypeOptionButton").item_selected.connect( func (index: int):
		choose_method.call(gate_info.name, index)
	)

	graph.add_child(new_gate)

	return new_gate


static func index_of_child(array: Array[Dictionary], key: Node) -> int:

	for index in array.size():
		if array[index]["Child"] == key:
			return index

	return -1


static func find_index_of_child_by_parent_name(array: Array[Dictionary], name: String) -> int:

	for index in array.size():
		if array[index]["Parent"].name == name:
			return index

	return -1


static func find_by_name(array: Array, name: String) -> Node:

	for node in array:
		if node.name == name:
			return node

	return null


static func find_index_by_name(array: Array, name: String) -> int:

	for index in array.size():
		if array[index].name == name:
			return index

	return -1


static func find_index_by_parent_name(array: Array, name: String) -> int:

	for index in array.size():
		if array[index].get_parent().name == name:
			return index

	return -1
		

static func load_graph(graph: GraphEdit, gates: Array[Gate], transmitters: Array[Dictionary], receivers: Array[Dictionary], type_choose_method: Callable) -> void:
	
	var r_graphnodes: Array[GraphNode] = []

	for receiver in receivers:
		var new_r := add_new_receiver(graph, receiver)
		r_graphnodes.append(new_r)
	
	for gate in gates:
		var new_g := add_new_gate(graph, gate, type_choose_method)

		for connectee in gate.receivers:
			var index := index_of_child(receivers, connectee)
			graph.connect_node(new_g.name, 0, r_graphnodes[index].name, 0)

		for connectee in gate.propagators:
			graph.connect_node(connectee.name, 0, new_g.name, 0)

	
	for transmitter in transmitters:
		var new_t := add_new_transmitter(graph, transmitter)

		var t_info: Array[TransmitterList] = transmitter["Child"].ports 

		for port in t_info.size():
			for conn_i in t_info[port].gate_names.size():
				if transmitter["Child"] not in find_by_name(gates, t_info[port].gate_names[conn_i]).transmitters:
					push_error("Transmitter tries to connect to gate that doesn't recognise it (", new_t.name , ":", port, " -> ", t_info[port].gate_names[conn_i], ")")
					continue
				graph.connect_node(new_t.name, port, t_info[port].gate_names[conn_i], 0)

	graph.arrange_nodes()