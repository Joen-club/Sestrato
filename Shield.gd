class_name Shield

extends Area2D

signal Frozen

func _ready():
	pass

func _init():
	collision_mask = 64

func Stun(var Seconds: int):
	emit_signal("Frozen", Seconds)

	
	
