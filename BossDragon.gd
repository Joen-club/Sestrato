extends KinematicBody2D

var Y_levels = [-2000, -1850, -1680]
var ArrayPos = 0
var Reload = false
export var Frequency: float

enum States {Regular, Rage, Irregular, Break, Steady}
var Boss_State = States.Break

var Velocity = Vector2.ZERO
var speed = 250
var Direction = Vector2.RIGHT

var DefaultPos = Vector2(2821, -2004)

export var Flame: PackedScene

onready var player = get_parent().get_node("Player")

func _ready():
	
	pass

func _physics_process(delta):
	match Boss_State:
		States.Regular:
			General()
			Regular_State(true)
			aim()

		States.Break:
			General()
			Velocity = Vector2.ZERO
			Default_Position()
			
		States.Irregular:
			Regular_State(false)
			General()
			aim()
			pass
		
		States.Steady:
			Go_Straight()
			pass
		
		States.Rage:
			Direction.x = 0
			General()
			Default_Position()
			pass
			
func General():
	$PlayerFollower.cast_to = to_local(player.position)
	if $PlayerFollower.cast_to.x < 0:
		$AnimatedSprite.flip_h = true
		$Sprite.position.x = -75
	else:
		$AnimatedSprite.flip_h = false
		$Sprite.position.x = 75

	Velocity = move_and_slide(Velocity, Vector2.UP)
	
func Regular_State(var Regular: bool):
	if Regular:
		Velocity.y = -100 if position.y >= Y_levels[0] else 0
		$Sprite/AnimationPlayer.set_speed_scale(1)
	else:
		Velocity.y = 100 if position.y <= Y_levels[1] else 0
		$Sprite/AnimationPlayer.set_speed_scale(1.2)
		
	if abs(position.x - player.position.x) <= abs(300):
		Direction.x = 1 if $PlayerFollower.cast_to.x < 0 else -1
		speed = 250
	elif abs(position.x - player.position.x) >= abs(500):
		Direction.x = -1 if $PlayerFollower.cast_to.x < 0 else 1
		speed = 250
		
	Velocity.x = Direction.x*speed
		
		
func aim():
	$Sprite/AnimationPlayer.play("Prepare")
	

func Regular_shoot(var FlameType: int):
	var Fire = Flame.instance()
	Fire.FlameType = FlameType
	Fire.speed = 650 if Boss_State == States.Irregular else 400
	Fire.Direction = $PlayerFollower.cast_to.normalized()
	Fire.position = position
	get_tree().current_scene.add_child(Fire)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Prepare":
		Regular_shoot(2)
	elif anim_name == "Steady":
		speed = 250

func _on_VisibilityNotifier2D_screen_exited():
	if Boss_State == States.Regular or Boss_State == States.Irregular:
		if position.x > player.position.x:
			position.x = 1470
		else:
			position.x = 3095
			
	elif Boss_State == States.Steady:
			ArrayPos += 1
			position.y = Y_levels[ArrayPos]
			$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
			if ArrayPos == 2:
				Boss_State == States.Break
				ArrayPos = 0

func _on_Portal_body_entered(body):
	Boss_State = States.Break

func Irregular_State():
	position.y = clamp(position.y, Y_levels[0], Y_levels[1])
	
	
func Default_Position() -> bool:
	var direction = (DefaultPos - position).normalized()
	var Distance = position.distance_to(DefaultPos)
	if Distance > 20:
		move_and_slide(direction*speed*1.5)
		return false
	else: return true
	
func Go_Straight():
	Velocity.y = 0
	Direction.x = -1 if $AnimatedSprite.flip_h else 1
	Velocity.x = Direction.x*speed*5.5
	
	Velocity = move_and_slide(Velocity, Vector2.UP)
	
func ShootWaves():
	if Reload == false:
		Regular_shoot(1)
		Reload = true
	elif Reload == true:
		yield(get_tree().create_timer(.2), "timeout")
		Reload = false


func _on_Area2D_body_entered(body):
	player._on_Enemy_KnockBack(position.x, position.y, 1)

func Died():
	$AnimationPlayer.play("Died")
	
