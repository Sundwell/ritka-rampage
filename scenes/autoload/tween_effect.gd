extends Node


func bouncing_appear(node: CanvasItem, tween: Tween) -> Tween:
	tween.tween_property(node, "scale", Vector2.ONE, 0.3) \
			.from(Vector2.ZERO) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	return tween
