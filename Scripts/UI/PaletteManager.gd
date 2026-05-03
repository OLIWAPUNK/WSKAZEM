class_name PaletteManager
extends CanvasLayer

@onready var rect: ColorRect = $Dither

enum Palette {
	MONO,
	RED,
	GREEN,
	YELLOW,
	PURPLE
}

const PALETTES = {
	Palette.MONO: {
		"texture": preload("res://assets/Textures/DitherPalettes/PaletteMono.png"),
		"contrast": 1.5,
		"offset": 0.0
	},
	Palette.RED: {
		"texture": preload("res://assets/Textures/DitherPalettes/PaletteRed.png"),
		"contrast": 2.0,
		"offset": 0.02
	},
	Palette.GREEN: {
		"texture": preload("res://assets/Textures/DitherPalettes/PaletteGreen.png"),
		"contrast": 1.4,
		"offset": 0.0
	},
	Palette.YELLOW: {
		"texture": preload("res://assets/Textures/DitherPalettes/PaletteYellow.png"),
		"contrast": 1.7,
		"offset": 0.02
	},
	Palette.PURPLE: {
		"texture": preload("res://assets/Textures/DitherPalettes/PalettePurple.png"),
		"contrast": 1.5,
		"offset": 0.0
	}
}

var current_palette: Palette = Palette.MONO

func _ready() -> void:
	Global.palette_manager = self

	if not is_in_group("GameEvents"):
		add_to_group("GameEvents")

	var saved_palette = Saves.get_data_or_null("current_palette")
	if saved_palette != null and saved_palette in Palette.values():
		set_palette(saved_palette)
	else:
		set_palette(Palette.MONO)

func set_palette(palette: Palette) -> void:
	var palette_data = PALETTES[palette]
	rect.set("shader_parameter/u_color_tex", palette_data["texture"])
	rect.set("shader_parameter/u_contrast", palette_data["contrast"])
	rect.set("shader_parameter/u_offset", palette_data["offset"])
	current_palette = palette

func on_save():
	Saves.set_data("current_palette", current_palette)