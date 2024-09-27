class_name FloatingText
extends Node2D

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
	var label_color = text_color_by_type[type]
	label.add_theme_color_override("font_color", Color(label_color))
	label.text = text
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position", global_position + (Vector2.UP * 32), .4)\
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector2.ZERO, .4)\
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	tween.chain()
	tween.tween_callback(queue_free)
