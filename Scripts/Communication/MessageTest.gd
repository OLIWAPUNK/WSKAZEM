@icon("res://Textures/EditorIcons/MessageTest.svg")
class_name MessageTest
extends Resource

@export var syntax_test: SyntaxTest
@export var gate_index: int


func _ready() -> void:
	assert(syntax_test, "No syntax test in %s" % self)
	assert(gate_index, "No gate index in %s" % self)
