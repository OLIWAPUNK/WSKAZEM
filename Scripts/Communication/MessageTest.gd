class_name MessageTest
extends Resource

@export var syntax_test: SyntaxTest
@export var gate_name: String


func _init() -> void:
    assert(syntax_test, "No syntax test in %s" % self)
    assert(gate_name, "No gate name in %s" % self)