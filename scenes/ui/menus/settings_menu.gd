class_name SettingsMenu
extends CanvasLayer

signal back_pressed

@onready var sfx_slider: HSlider = %SfxSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var window_mode_button: Button = %WindowButton
@onready var back_button: Button = %BackButton
@onready var margin_container: MarginContainer = $MarginContainer
@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer


func _ready() -> void:
	sfx_slider.value_changed.connect(on_slider_volume_changed.bind(Constants.AUDIO_BUSES.SFX))
	music_slider.value_changed.connect(on_slider_volume_changed.bind(Constants.AUDIO_BUSES.Music))
	window_mode_button.pressed.connect(on_window_mode_pressed)
	back_button.pressed.connect(on_back_pressed)
	
	update_displayed_values()
	
	
func set_ui_position(position: Constants.UIPositions = Constants.UIPositions.CENTER):
	match position:
		Constants.UIPositions.RIGHT:
			margin_container.add_theme_constant_override('margin_right', 100)
			panel_container.size_flags_horizontal = Control.SIZE_SHRINK_END
			

func update_window_mode_display():
	var mode_text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		mode_text = "Fullscreen"
		
	window_mode_button.text = mode_text


func update_displayed_values():
	sfx_slider.value = get_bus_volume_percent(Constants.AUDIO_BUSES.SFX)
	music_slider.value = get_bus_volume_percent(Constants.AUDIO_BUSES.Music)
	update_window_mode_display()


func set_bus_volume_percent(bus_name: String, new_volume: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_volume))


func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	var bus_volume_db: float = AudioServer.get_bus_volume_db(bus_index)
	
	return db_to_linear(bus_volume_db)


func on_slider_volume_changed(new_volume: float, bus_name: String) -> void:
	set_bus_volume_percent(bus_name, new_volume)


func on_window_mode_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	update_window_mode_display()
	

func on_back_pressed():
	back_pressed.emit()
	
