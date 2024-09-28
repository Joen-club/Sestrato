extends KinematicBody2D

export var Magic: PackedScene
var Current_State = States.AIR
var velocity = Vector2.ZERO
var Gravity = 600
var SeeYou: = false
var player
var Dodge = Timer.new()
var Reloaded = true
var RememberedPos
var PlayerPosition = Vector2(0,0)

enum States {AIR, FLOOR}

func _ready():
	RememberedPos = position
	Dodge.connect("timeout",self, "Dodged")
	Dodge.set_one_shot(true)
	add_child(Dodge)
	player = get_parent().get_parent().find_node("Player", true, true)

func _physics_process(delta):
	match Current_State:
		States.AIR:
			ForAIR(delta)
			if is_on_floor():
				Current_State = States.FLOOR
				continue
		States.FLOOR:
			ForFLOOR()
			if not is_on_floor():
				Current_State = States.AIR
				continue

func ForAIR(delta):
	if $CeilingDetecter.is_colliding():
		position.y += 50
	velocity.y += Gravity*delta
	move_and_slide(velocity, Vector2.UP)
	
func ForFLOOR():
	if $CeilingDetecter.is_colliding():
		position.y += 50
	if $FloorDetect.is_colliding():
		RememberedPos = position
	velocity.y = 20
	if SeeYou == false:
		return
	$TakeAim.cast_to = to_local(player.position)
	PlayerPosition = $TakeAim.cast_to.normalized()
	shoot()
	move_and_slide(velocity, Vector2.UP)
	
func shoot():
	if Reloaded == false:
		return
	Reloaded = false
	var FrostBall = Magic.instance()
	FrostBall.position = position + Vector2(-27, -8)
	get_tree().current_scene.add_child(FrostBall)
	yield(get_tree().create_timer(randi() % 3 + 2), "timeout")
	Reloaded = true

func Dodged():
	position.y += -200
	Gravity = 0
	if player.position.x > position.x:
		$RayCast2D.cast_to.x = -150
		if not $RayCast2D.is_colliding():
			position.x += -100
	else:
		$RayCast2D.cast_to.x = 150
		if not $RayCast2D.is_colliding():
			position.x += 100
	yield(get_tree().create_timer(.4),"timeout")
	Gravity = 600

func _on_VisibilityNotifier2D_screen_entered():
	SeeYou = true

func _on_VisibilityNotifier2D_screen_exited():
	SeeYou = false

func _on_Dodge_area_entered(area):
	Dodge.start(0.23)
	

func Return():
	position = RememberedPos

func _on_PJ_Check_area_entered(area):
	Dodge.stop()
	area.queue_free()
	$AnimationPlayer.play("Death")
	pass # Replace with function body.
