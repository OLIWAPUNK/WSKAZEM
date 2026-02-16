class_name CutsceneManager
extends Node

@export var cutscenes: Dictionary[String, Cutscene] = {}

func _ready() -> void:
	Global.cutscene_manager = self

func play_cutscene(cutscene_name: String) -> Signal:
	assert(cutscene_name in cutscenes, "Cutscene not found: " + cutscene_name)
	return cutscenes[cutscene_name].play_cutscene()