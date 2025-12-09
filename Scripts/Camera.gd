extends Camera3D

@export var FOLLOW_SPEED := 10.0
@export var TARGET: Node3D

func _process(delta: float) -> void:
	position = lerp(position, TARGET.position, FOLLOW_SPEED * delta)
