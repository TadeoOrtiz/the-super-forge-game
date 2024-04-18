class_name Projectile
extends HitBoxNode

func _physics_process(delta):
	var direction: Vector2 = Vector2.RIGHT
	global_position += direction.rotated(rotation) * 500 * delta