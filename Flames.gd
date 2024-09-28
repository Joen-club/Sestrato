extends Area2D

export var FlameType: int

export var speed = 400
var Direction = Vector2.ZERO

var player

func _ready():
	player = get_parent().find_node("Player", true, true)
	look_at(player.position)
	if FlameType == 1:
		speed = 750
		$Sprite.texture = load("res://enemies/BossFight/Dragon/FlameWave3.png")
#		look_at(player.position)
		$CollisionShape2D.disabled = true
		$AnimationPlayer.play("FlameWave")
		$Particles2DWave.emitting = true
	elif FlameType == 2:
		$Sprite.texture = load("res://enemies/BossFight/Dragon/Flame.png")
		$AnimationPlayer.play("Rotate")
		$CollisionPolygon2D.disabled = true
		scale = Vector2(0.7, 0.7)
	
func _physics_process(delta):
	position += Direction * speed *delta

func _on_VisibilityNotifier2D_screen_exited():
	yield(get_tree().create_timer(.4), "timeout")
	queue_free()
	pass # Replace with function body.


func _on_Flames_body_entered(body):
	player._on_Enemy_KnockBack(position.x, 200000, 0.3*FlameType)
	pass # Replace with function body.


func _on_Flames_area_entered(hitbox: Shield):
	if hitbox == null:
		return
	
	if FlameType == 2:
		Absorb()
		hitbox.Stun(3)

func Absorb():
	queue_free()
