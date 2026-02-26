class_name UIManager
extends Node

@onready var communication_container: MarginContainer = $'../CommunicationContainer'



func _ready() -> void:
	
	Global.ui_manager = self
	communication_container.visible = false

func is_visible() -> bool:
	return communication_container.visible

func set_visible(visible: bool) -> void:
	communication_container.visible = visible


