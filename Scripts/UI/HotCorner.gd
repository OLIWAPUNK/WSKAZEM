extends Control

@onready var pause_menu: PauseMenu = $"../PauseMenu"
@onready var circle: TextureRect = $Circle

func _process(_delta: float) -> void:
    if Global.is_loading or pause_menu.visible:
        visible = false
        return
    visible = true

    var mouse_pos = get_viewport().get_mouse_position()
    var screen_size = get_viewport().get_visible_rect().size
    var distance_to_corner = mouse_pos.distance_to(Vector2.ZERO)
    var max_distance = screen_size.length() * 0.1
    var scale_factor = 0.5 - clamp(distance_to_corner / max_distance, 0.0, 0.5)
    circle.scale = Vector2.ONE * scale_factor
    if distance_to_corner < 10 and not pause_menu.visible:
        visible = false
        pause_menu.toggle()