extends SubViewportContainer


@onready var subview: SubViewport = $GameViewport


func _ready() -> void:
	Global.game_viewport_container = self
