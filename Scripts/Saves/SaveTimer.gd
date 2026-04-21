extends Timer

func _ready() -> void:
	connect("timeout", _on_timeout)

func _on_timeout() -> void:
	Saves.save()