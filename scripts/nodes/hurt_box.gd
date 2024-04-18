class_name HurtBoxNode
extends Area2D

enum HURT_BOX_MODE {
	DisableOnHit,
	Always
}

signal hurt(value: float)

@export var mode := HURT_BOX_MODE.Always
@export_range(0.001, 2) var disabled_time: float = 0.001

@onready var collision: CollisionShape2D = %CollisionShape2D
@onready var disabled_timer: Timer = %DisableTimer

func _ready():
	disabled_timer.wait_time = disabled_time

func _on_area_entered(area: Area2D):
	if area is HitBoxNode:
		match mode:
			HURT_BOX_MODE.Always:
				pass
			HURT_BOX_MODE.DisableOnHit:
				collision.call_deferred("set", "disabled", true)
				disabled_timer.start()
		if area is Projectile:
			area.queue_free()
		hurt.emit(area.damage)
		
func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)
