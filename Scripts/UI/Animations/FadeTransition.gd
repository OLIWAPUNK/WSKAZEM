class_name FadeTransition
extends ColorRect

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	visible = false
	anim_player.connect("animation_finished", _on_animation_finished)

func fade_in() -> Signal:
	visible = true
	anim_player.play("fade_in")
	return anim_player.animation_finished

func fade_out() -> Signal:
	visible = true
	anim_player.play("fade_out")
	return anim_player.animation_finished

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		visible = false