class_name GateReceiver
extends Node

signal receive(gate_name: String)
 
@onready var parent: Node = $".."

@export_multiline var description: String


func _ready() -> void:
	assert(parent, "No parent")


func signal_receive(gate: Gate) -> void:
	receive.emit(gate.name)