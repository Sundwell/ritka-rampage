class_name FloatingText
extends Node2D

const LITTLE_NUMBER_SCALE = 0.25
const MIN_SCALE = 0.35
const MAX_SCALE = 0.7

enum Type {
	DAMAGE,
	HEAL,
	ORANGE_PICK_UP
}

var text_color_by_type = {
	Type.DAMAGE: "#ff5454",
	Type.HEAL: "#83ff3d",
	Type.ORANGE_PICK_UP: "#ff9f3d",
}

@onready var label = $Label


func start(text: String, type: Type = Type.DAMAGE):
	if int(text) is int:
		z_index = min(1, int(text))
	
	if type == Type.DAMAGE:
		var amount = float(text)
		if amount is float:
			var scale_multiplier = clamp(MIN_SCALE + (amount / 40), MIN_SCALE, MAX_SCALE)
			
			if amount < 2.0:
				scale_multiplier = LITTLE_NUMBER_SCALE
			scale = Vector2(scale_multiplier, scale_multiplier)
	
	var label_color = text_color_by_type[type]
	label.add_theme_color_override("font_color", Color(label_color))
	label.text = text
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.set_parallel()
	tween.tween_property(self, "position", global_position + (Vector2.UP * 16), 0.35)
	tween.tween_property(self, "scale", scale * 1.2, 0.10)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.25).set_delay(0.10)
	tween.chain()
	tween.tween_callback(queue_free)
