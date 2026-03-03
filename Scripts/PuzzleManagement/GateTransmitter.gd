@icon("res://Textures/EditorIcons/GateTransmitter.svg")
class_name GateTransmitter
extends Node

@onready var parent: Node = $".."

@export var available_gates: Array[String]
@export var descriptions: Array[String]
@export_multiline var node_description: String


func _ready() -> void:
	assert(parent, "No parent")


func gate_transmit(gate_index: int) -> void:

	if gate_index < 0 or gate_index >= available_gates.size():
		push_error("Gate index #%s not available in %s" % [gate_index, self])
		return
		
	Global.state_machine.call_gate(available_gates[gate_index], self)
