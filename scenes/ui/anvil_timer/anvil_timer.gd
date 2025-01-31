extends CanvasLayer

@export var anvil_manager: AnvilManager

@onready var time_to_spawn_label: Label = %TimeToSpawnLabel
@onready var anvil_texture: TextureRect = %AnvilTexture


func _ready() -> void:
	GameEvents.anvil_spawned.connect(_on_anvil_spawned)
	
	if anvil_manager:
		anvil_manager.time_to_spawn_changed.connect(_on_time_to_spawn_changed)


func _on_time_to_spawn_changed(time_to_spawn: float) -> void:
	time_to_spawn_label.text = str(time_to_spawn)


func _shake_anvil():
	var pivot_tween = create_tween()
	anvil_texture.pivot_offset = Vector2(8, 8)
	pivot_tween.tween_property(anvil_texture, 'pivot_offset', Vector2(8, 8), 0.5)

	var tween = create_tween()
	tween.tween_property(anvil_texture, 'rotation_degrees', 15, 0.1)
	tween.tween_property(anvil_texture, 'rotation_degrees', -15, 0.1)
	tween.tween_property(anvil_texture, 'rotation_degrees', 7, 0.1)
	tween.tween_property(anvil_texture, 'rotation_degrees', -7, 0.1)
	tween.tween_property(anvil_texture, 'rotation_degrees', 0, 0.1)


func _on_anvil_spawned():
	_shake_anvil()
