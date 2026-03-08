class_name SliderSetting
extends Setting

@onready var preview_label: Label = $PreviewLabel

func _ready() -> void:
	super._ready()

	var default_value = get_default_value() as float
	var current_value = get_current_value() as float

	var slider = setting_control as HSlider
	slider.max_value = default_value * 2 if default_value > 0 else 1.0
	slider.step = default_value / 10 if default_value > 0 else 0.1
	slider.tick_count = int((slider.max_value - slider.min_value) / slider.step) + 1	
	slider.ticks_on_borders = true
	slider.value = current_value
	
	slider.connect("drag_ended", _on_drag_ended)
	slider.connect("value_changed", _on_value_changed)

	preview_label.text = str(slider.value)

func _on_value_changed(value: float) -> void:
	preview_label.text = str(value)

func _on_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var slider = setting_control as HSlider
		emit_setting_updated(slider.value)

func refresh() -> void:
	var slider = setting_control as HSlider
	slider.value = get_current_value() as float
	preview_label.text = str(slider.value)
