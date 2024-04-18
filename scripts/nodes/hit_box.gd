class_name HitBoxNode
extends Area2D

@export var damage: float
@export var disabled: bool:
	set(value):
		disabled = value
		$CollisionShape2D.call_deferred("set", "disabled", disabled)