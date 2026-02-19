class_name StateMachine
extends Node

@export var gates: Dictionary[String, Gate] = {}


func _ready() -> void:

	for child in get_children():
		assert(child is Gate, "StateMachine has non-Gate child")
		gates[child.name] = child


func call_gate(gate_name: String, transmitter: GateTransmitter) -> bool:

	var called_gate: Gate = gates.get(gate_name)
	if not called_gate:
		return false

	called_gate.update(transmitter)

	return true
