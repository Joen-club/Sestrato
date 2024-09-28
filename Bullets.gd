class_name Bullets

extends Area2D
var Direction = Vector2.ZERO
var Speed = 600
var Reflected = false


func _ready():
	connect("area_entered", self, "_on_area_entered")

func _init():
	collision_layer = 64

func _physics_process(delta):
	position += Direction * Speed * delta
	if Direction.x < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

func Reflect():
	Reflected = true
	Direction = -Direction
	set_collision_mask_bit(4, true)
	set_collision_mask_bit(0, false)

func _on__screen_exited():
	queue_free()

func _on_Bullets_body_entered(body):
	if body.get_collision_layer_bit(1):
		queue_free()
	elif Reflected == true:
		queue_free()
	else:
		if body.get_collision_mask_bit(4) == true:
			if $Sprite.flip_h == true:
				body._on_Enemy_KnockBack(200000, 20000, 0.7)
			else: body._on_Enemy_KnockBack(-200000, 20000, 0.7)
	queue_free()

func _on_area_entered(hitbox: Shield):
	if hitbox == null:
		return
	
	if has_method("Reflect"):
		Reflect()
