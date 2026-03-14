@tool
@icon("res://Textures/EditorIcons/GateTransmitter.svg")
class_name GateTransmitter
extends Node

@onready var parent: Node = $".."

@export var ports: Array[TransmitterList]
@export var port_descriptions: Array[TransmitterDescription]
@export_multiline var node_description: String


func _ready() -> void:
	assert(parent, "No parent")
	assert(ports.size() == port_descriptions.size(), "Names and descriptions doesn't match")


func gate_transmit(gate_index: int) -> void:

	if gate_index < 0 or gate_index >= ports.size():
		push_error("Gate index #%s not available in %s" % [gate_index, self])
		return

	for to_gate in ports[gate_index].gate_names:
		print(to_gate)
		if to_gate == "":
			push_warning("%s: Empty gate_name port nr %s", self, to_gate)
			continue
			
		print(self, ":", gate_index)
		Global.state_machine.call_gate(to_gate, self)
