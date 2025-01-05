class_name TickStatus
extends Status

signal tick(value: float)

enum Type {
	DAMAGE,
	HEAL
}

@export var tick_timer: Timer
@export var tick_time: float = 1.0
@export var tick_value: float
var type: Type = Type.DAMAGE


func _ready() -> void:
	super()
	
	if not tick_timer:
		push_error('Tick Timer must be specified')
		return
		
	tick_timer.wait_time = tick_time
	tick_timer.start()
	tick_timer.timeout.connect(_on_tick_timer_timeout)
	
	
func _refresh_tick_timer():
	var should_fasten_timer: bool = tick_time <= tick_timer.time_left
	tick_timer.wait_time = tick_time
	
	if should_fasten_timer:
		tick_timer.start()
	
	
func setup(_tick_value: float, _duration: float, _tick_time: float = 1.0, _type: Type = Type.DAMAGE) -> void:
	tick_value = max(0, _tick_value)
	duration = _duration
	tick_time = _tick_time
	type = _type
	
	
func refresh_with(status: TickStatus):
	setup(status.tick_value, status.duration, status.tick_time, status.type)
	_refresh_tick_timer()
	_refresh_duration_timer()
	

func _on_tick_timer_timeout() -> void:
	tick.emit(tick_value)
