class_name UIManager
extends Node

@onready var communication_container: MarginContainer = $'../CommunicationContainer'



func _ready() -> void:
	
	Global.ui_manager = self
	communication_container.visible = false


