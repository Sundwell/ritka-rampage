extends Node

@export var default_texture: Texture
@export var base_cursor_size := 32
var scale_multiplier := 1
var base_viewport_size: Vector2
var cursor_size: int:
	get():
		return scale_multiplier * base_cursor_size
var cursor_offset: int:
	get():
		return cursor_size / 2


func _ready() -> void:
	_update_cursors()
	base_viewport_size = get_viewport().get_visible_rect().size
	get_tree().root.size_changed.connect(_update_cursors)
	
	
func _update_cursors() -> void:
	var viewport_size: Vector2 = get_viewport().size
	
	var scaled_texture = ImageTexture.new()
	
	Input.set_custom_mouse_cursor(default_texture, Input.CURSOR_ARROW, Vector2(cursor_offset, cursor_offset))
	Input.set_custom_mouse_cursor(default_texture, Input.CURSOR_POINTING_HAND, Vector2(cursor_offset, cursor_offset))
