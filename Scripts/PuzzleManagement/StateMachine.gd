class_name StateMachine
extends Node


var transmitters: Array[GateTransceiver] = []
var receivers: Array[GateTransceiver] = []

@export var gates: Dictionary[String, Gate] = {}


func _ready() -> void:

	for child in get_children():
		assert(child is Gate, "StateMachine has non-Gate child")
		gates[child.name] = child


func call_gate(gate_name: String, state: bool, transceiver: GateTransceiver) -> bool:
	
	var called_gate: Gate = gates.find_key(gate_name)
	if not called_gate:
		return false

	called_gate.update(transceiver, state)

	return true
