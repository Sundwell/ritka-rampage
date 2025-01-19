class_name PistolWeaponVariant
extends WeaponVariant

@onready var shoot_sound: AudioStreamPlayer = $SFX/ShootSound


func play_shoot_animation():
	animation_player.play('shoot')
	

func play_shoot_sound():
	shoot_sound.pitch_scale = randf_range(1, 1.1)
	shoot_sound.play()
