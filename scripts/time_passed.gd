extends Label

signal time_changed(seconds: int)

var seconds_passed := 0:
	set(value):
		seconds_passed = value
		time_changed.emit(seconds_passed)
		text = str(floor(float(value) / 60)).lpad(2, '0') + ':' + str(value % 60).lpad(2, '0')

func _on_timer_timeout():
	seconds_passed += 1
