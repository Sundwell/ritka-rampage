class_name CardAnimatorComponent
extends Node

signal selected_finished
signal in_finished

@export var card: Control


func play_in(delay := 0.0):
	card.modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	var tween = create_tween()
	card.modulate = Color.WHITE
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(card, "scale", Vector2.ZERO, 0)
	tween.tween_property(card, "scale", Vector2.ONE, 0.3)
	tween.tween_callback(in_finished.emit)
	
	
func play_out():
	var tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(card, "scale", Vector2.ZERO, 0.15)
	tween.tween_property(card, "modulate:a", 0, 0.15)
	
	
func play_selected():
	var tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(card, "position:y", -20, 0.3)
	tween.tween_property(card, "scale", Vector2(1.3, 1.3), 0.3)
	tween.chain()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(card, "position:y", 0, 0.1)
	tween.tween_property(card, "scale", Vector2(0, 0), 0.1)
	tween.chain()
	tween.tween_callback(selected_finished.emit)
	
	
func play_hover_in():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(card, "position:y", -10, 0.1)
	tween.tween_property(card, "scale", Vector2(1.1, 1.1), 0.1)
	
	
func play_hover_out():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(card, "position:y", 0, 0.1)
	tween.tween_property(card, "scale", Vector2.ONE, 0.1)
