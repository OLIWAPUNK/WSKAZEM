extends SubViewportContainer


@onready var subview: SubViewport = $GameViewport


func _ready() -> void:
	Global.game_viewport_container = self
	

func _input(event: InputEvent) -> void:
	subview.push_input(event)
