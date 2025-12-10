extends CanvasLayer

signal on_transition_finished

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var TRANSITION_DURATION := 0.25

func _ready() -> void:
	_set_duration()

	color_rect.visible = false
	animation_player.connect("animation_finished", self._on_animation_finished)

func transition() -> Signal:
	color_rect.visible = true
	animation_player.play("fade_out")
	return on_transition_finished

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_out":
		on_transition_finished.emit()
		animation_player.play("fade_in")
	elif anim_name == "fade_in":
		color_rect.visible = false

func _set_duration() -> void:
	animation_player.get_animation("fade_out").length = TRANSITION_DURATION
	animation_player.get_animation("fade_in").length = TRANSITION_DURATION
	animation_player.get_animation("fade_out").track_set_key_time(0, 1, TRANSITION_DURATION)
	animation_player.get_animation("fade_in").track_set_key_time(0, 1, TRANSITION_DURATION)