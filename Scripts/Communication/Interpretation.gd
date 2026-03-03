@icon("res://Textures/EditorIcons/Interpretation.svg")
class_name Interpretation
extends Node

@export var message_tests: Array[MessageTest] = []
@export var on_success_transmit: GateTransmitter
@export var default_gate_index: int = -1


func _ready() -> void:
	assert(on_success_transmit, "No transmitter set in %s" % self)


func interpret(messgage: Array[GestureData]) -> void:

	for test in message_tests:
		if test.syntax_test.run_syntax_test(messgage):
			on_success_transmit.gate_transmit(test.gate_index)
			return
	
	if default_gate_index < 0:
		on_success_transmit.gate_transmit(default_gate_index)