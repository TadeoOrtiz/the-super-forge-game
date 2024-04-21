extends WeaponModel

func on_attack():
	$Shoot.pitch_scale = randf_range(0.99, 1.1)
	spawn_bullet()