@icon("res://Textures/EditorIcons/GateTransmitter.svg")
class_name GateTransmitter
extends Node

@onready var parent: Node = $".."

@export_multiline var description: String


func _ready() -> void:
	assert(parent, "No parent")


func gate_transmit(gate_name: String) -> void:
	Global.state_machine.call_gate(gate_name, self)
