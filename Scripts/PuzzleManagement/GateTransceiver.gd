class_name GateTransceiver
extends Node

signal gate_receive(gate_name: String)

@onready var parent: Area3D = $".."

@export var can_receive: bool = false
@export var can_transmit: bool = false


func _ready() -> void:
	assert(parent, "No parent")


func gate_transmit(gate_name: String, state: bool) -> void:
	
	if can_transmit:
		%StateMachine.call_gate(gate_name, state, self)


func signal_receive(gate_name: String) -> void:
	
	if not can_receive:
		return

	gate_receive.emit(gate_name)