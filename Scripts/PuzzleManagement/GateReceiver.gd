class_name GateReceiver
extends Node

signal gate_receive(gate_name: String)
 
@onready var parent: Node = $".."

@export_multiline var description: String


func _ready() -> void:
	assert(parent, "No parent")


func signal_receive(gate: Gate) -> void:
	print(self, " RECEIVE")
	gate_receive.emit(gate.name)