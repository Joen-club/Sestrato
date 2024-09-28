extends Area2D
var Direction = Vector2.RIGHT
var Speed = 600

onready var Game_Data = SaveFile.game_data

func _ready():
	if Game_Data.Map == "res://Level5.tscn":
		self.set_collision_mask_bit(1, false)
	connect("area_entered", self, "_on_area_entered")

func _physics_process(delta):
	position += Direction * Speed * delta
	if Direction.x < 0:
		$Sprite.flip_h = true
	else: $Sprite.flip_h = false


func _on_screen_exited():
	yield(get_tree().create_timer(.3), "timeout")
	queue_free()

func _on_area_entered(hitbox: Shield):
	if hitbox == null:
		return
	
	Direction *= -1


func _on_Projectiles_body_entered(body):
	if body.get_collision_layer_bit(1):
		queue_free()
	elif body.get_collision_layer_bit(0) and $Sprite.flip_h == true:
		body._on_Enemy_KnockBack(200000, 20000, 0.6)
		queue_free()
	elif body.get_collision_layer_bit(0) and $Sprite.flip_h == false:
		body._on_Enemy_KnockBack(-200000, 20000, 0.6)
		queue_free()
	if body.is_in_group("Rejectable"):

		Direction *= -1
		set_collision_layer_bit(6, true)
		set_collision_mask_bit(0, true)
