class_name Weapon
extends Item

enum SHOOT_TYPE{
    SemiAuto,
    Auto
}

@export var model: PackedScene
@export var dispersion: float
@export var shoot_type := SHOOT_TYPE.SemiAuto