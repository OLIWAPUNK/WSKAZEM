class_name CutsceneManager
extends Node

var cutscenes: Dictionary[String, Cutscene] = {}

func _ready() -> void:
	Global.cutscene_manager = self

	for child in get_children():
		if child is Cutscene:
			var cutscene = child as Cutscene
			cutscenes[cutscene.cutscene_identifier] = cutscene

func play_cutscene(cutscene_name: String, animation_name: String = "") -> Signal:
	assert(cutscene_name in cutscenes, "Cutscene not found: " + cutscene_name)
	return cutscenes[cutscene_name].play_cutscene(animation_name)