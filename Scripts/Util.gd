class_name Util

static func normalize(value, _min, _max):
	return (value - _min) / (_max - _min)
	
static func get_mouse_position_normalized(viewport: Viewport):
	var screen_size = viewport.get_visible_rect().size
	var mouse_position = viewport.get_mouse_position()
	mouse_position.x = clamp(Util.normalize(mouse_position.x, 0, screen_size.x), 0.0, 1.0)
	mouse_position.y = clamp(Util.normalize(mouse_position.y, 0, screen_size.y), 0.0, 1.0)
	
	return mouse_position

static func clamp_to_sphere(vec: Vector3, radius: float):
	var m = vec.length()
	
	if m > radius:
		return vec / m * radius
	else:
		return vec
