@icon("res://assets/Textures/EditorIcons/ConditionalBehaviour.svg")
class_name ConditionalBehaviour
extends Resource


@export var syntax_test: SyntaxTest
@export var next_thought: int = -1
@export var reaction: Reaction
@export var transmition_gate_index: int = -1


## Wyłącznie dla wygody, opis nie ma znaczenia w kodzie
@export_multiline var behaviour_description: String