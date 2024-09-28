extends KinematicBody2D

onready var RayRayCast = $RayCast2D
onready var BulletTime = $Timer
export var ammo: PackedScene
var Jump_Timer = Timer.new()
var speed = 2000
var direction = 0
var velocity = Vector2.ZERO
var Here = false
signal ItHits
var player
var Gravity = 0
enum States {Idle, Agressive, Anxious}
var state = States.Idle
var Direction = 0
var Knocked = false

func _ready():
	SetupTimers()
	player = get_parent().get_parent().find_node("Player", true, true)

func _physics_process(delta):
	if is_on_floor():
		Knocked = false
	if $Control/ProgressBar.value == $Control/ProgressBar.min_value:
		queue_free()
	if $BodyChecker.is_colliding():
		position.y -= 90
	
	_check_player_collision()
	_aim()
	match state:
		States.Idle:
			if Knocked == false:
				if $Sprite.flip_h == true:
					Direction = -1
				elif $Sprite.flip_h == false:
					Direction = 1
				velocity.x += Direction*speed*delta*0.5
				$FloorChecker.position.x = $CollisionShape2D2.shape.get_extents().x*Direction
				$WallChecker.cast_to.x = 40*Direction
				if not $FloorChecker.is_colliding() and is_on_floor() or $WallChecker.is_colliding():
					Direction *= -1
					$Sprite.flip_h = not $Sprite.flip_h
					$WallChecker.cast_to.x = 40*Direction
					$FloorChecker.position.x = $CollisionShape2D2.shape.get_extents().x*Direction
		States.Agressive:
				velocity.x += direction * speed * delta
				if $Sprite.flip_h == true:
					Direction = 1
				elif $Sprite.flip_h == false:
					Direction = -1
				$FloorChecker.position.x = $CollisionShape2D2.shape.get_extents().x*Direction
				if not $FloorChecker.is_colliding():
					position.x += RayRayCast.cast_to.x*2 if RayRayCast.cast_to.x < 300 else RayRayCast.cast_to.x*1.4
				Turn()
				
				if Here == false:
					state = States.Idle
					continue
	
	if not $FloorChecker2.is_colliding():
		velocity.y += Gravity*delta
		Gravity = 700
	else: Gravity = 0
	velocity.x = lerp(velocity.x, 0, 0.1)
	_TimeToRun(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func Turn():
	if position.x > player.position.x:
		$Sprite.flip_h = true
	elif position.x < player.position.x:
		 $Sprite.flip_h = false

func _aim():
	RayRayCast.cast_to = to_local(player.position)

func _check_player_collision():
	if Here == true:
		if RayRayCast.get_collider() == player:
			$AnimationPlayer.play("PYA")
			state = States.Agressive
		elif RayRayCast.get_collider() != player and $AnimationPlayer.is_playing():
			$AnimationPlayer.stop()
			state = States.Idle
	elif Here == false:
		state = States.Idle
		$AnimationPlayer.stop()

func _shoot():
	var bullet = ammo.instance()
	bullet.position = position
	bullet.Direction = (RayRayCast.cast_to).normalized()
	get_tree().current_scene.add_child(bullet)

func SetupTimers():
	Jump_Timer.connect("timeout", self, "JUMP")
	Jump_Timer.set_one_shot(false)
	add_child(Jump_Timer)

func JUMP():
	$SuperPYA.play("SuperPYA")

func _TimeToRun(delta):
	if Here == true:
		if position.x < player.position.x and RayRayCast.cast_to.x != 0:
			direction = -100/RayRayCast.cast_to.x
			if player.position.x - position.x <= 100:
				position.x += RayRayCast.cast_to.x*3 if player.position.x - position.x > 60 else 0
		elif position.x > player.position.x and RayRayCast.cast_to.x != 0:
			direction = -100/RayRayCast.cast_to.x
			if position.x - player.position.x <= 100:
				position.x += RayRayCast.cast_to.x*3 if position.x - player.position.x > -60 else 0

func _on_Area2D_body_entered(body):
	Jump_Timer.start(rand_range(1.45,3.45))

func _on_Area2D_body_exited(body):
	Jump_Timer.stop()

func _on_screen_exited():
	yield(get_tree().create_timer(.5), "timeout")
	state = States.Idle
	Here = false

func _on_screen_entered():
	yield(get_tree().create_timer(.5), "timeout")
	Here = true

func _on_AnimationPlayer_animation_finished(anim_name):
	_shoot()

func _on_PJ_Check_area_entered(area):
	if $Control/ProgressBar.value <= 20 and not area.get_collision_layer_bit(6):
		pass
	else: $Control/ProgressBar.value -= 20
	area.queue_free()

func _on_SuperPYA_animation_finished(anim_name):
	_shoot()
	velocity.y = -500
	yield(get_tree().create_timer(.1), "timeout")
	_shoot()

func KnockIT(var POSX):
	Knocked = true
	if position.x > POSX:
		velocity.x = 700
	else:
		velocity.x = -700
	velocity.y = -500
