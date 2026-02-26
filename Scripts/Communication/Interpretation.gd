@icon("res://Textures/EditorIcons/Interpretation.svg")
class_name Interpretation
extends Node

@export var message_tests: Array[MessageTest] = []
@export var on_success_transmit: GateTransmitter
@export var default_gate: String


func _ready() -> void:
	assert(on_success_transmit, "No transmitter set in %s" % self)


func interpret(messgage: Array[GestureData]) -> void:

	for test in message_tests:
		if test.syntax_test.run_syntax_test(messgage):
			on_success_transmit.gate_transmit(test.gate_name)
			return
	
	if default_gate:
		on_success_transmit.gate_transmit(default_gate)