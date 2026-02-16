class_name CutsceneManager
extends Node

@export var cutscenes: Dictionary[String, Cutscene] = {}

func _ready() -> void:
	pass	

func play_cutscene(cutscene_name: String) -> void:
	assert(cutscene_name in cutscenes, "Cutscene not found: " + cutscene_name)
	cutscenes[cutscene_name].play()