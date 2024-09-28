extends KinematicBody2D

var velocity = Vector2(0,0)
var velocity2 = Vector2(0,0)
var direction = -1
var speed = 50
var Attack = false
var Turn = false
var Knocked = false
export var DetectsCliffs = true
export var Upgrade = false
export var Large = false
signal KnockBack

func _ready():
	$Checkers/FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x *direction
	$Checkers/FloorChecker.enabled = DetectsCliffs
	if Upgrade:
		$AnimatedSprite.self_modulate = "32ff00"
		$Checkers/BackChecker.cast_to.x += 160
		$Checkers/PlayerChecker.cast_to.x += -150
	if Large:
		scale = Vector2(1.75, 1.75)
	
func _physics_process(delta):
	if Knocked == true:
		velocity = Vector2.ZERO
		velocity2.y += 500*delta
	if is_on_floor():
		Knocked = false
	if not $Checkers/FloorChecker.is_colliding() and not $ATTAACK.is_playing() and DetectsCliffs == true and is_on_floor() or $Checkers/WallChecker.is_colliding():
	
		direction = direction *-1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$Checkers/FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x *direction
		if Attack == true and DetectsCliffs and not Upgrade:
			velocity.x = 0
	elif $Checkers/BackChecker.is_colliding() and not Turn:
		Turn()
		$Checkers/BackChecker.set_collision_mask_bit(0, false)

	if $AnimatedSprite.flip_h:
		$Checkers/BackChecker.rotation_degrees = 180
		$Checkers/PlayerChecker.rotation_degrees =180
		$Checkers/WallChecker.rotation_degrees = 180
	else: 
		$Checkers/PlayerChecker.rotation_degrees = 0
		$Checkers/BackChecker.rotation_degrees = 0
		$Checkers/WallChecker.rotation_degrees = 0
	if $Checkers/PlayerChecker.is_colliding() and Attack == false and Turn == false:
		$ATTAACK.play("PrepareYourAnus")

	Movement(delta)
	velocity.y += 500*delta
	if direction == 1:
		$AnimatedSprite.flip_h == true
	else: $AnimatedSprite.flip_h = false
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity2 = move_and_slide(velocity2, Vector2.UP)
	if Knocked == false:
		velocity2.x = lerp(velocity2.x, 0,  0.2)
		velocity2.y = lerp(velocity2.y, 0, 0.2)

func Movement(delta):
	if Attack == false and Knocked == false and is_on_floor():
		velocity.x = speed*direction if not Upgrade else speed*direction*2.3

func _on_Area2D_body_entered(body):
	if body.get_collision_mask_bit(4) == false:
		return
	if not Upgrade:
		set_collision_mask_bit(0, false)
		set_collision_layer_bit(4, false)
		$TopChecker.set_collision_layer_bit(4, false)
		$TopChecker.set_collision_mask_bit(0, false)
		$SidesChecker.set_collision_layer_bit(4, false)
		$SidesChecker.set_collision_mask_bit(0, false)
		$BottomChecker.set_collision_layer_bit(4, false)
		$BottomChecker.set_collision_mask_bit(0, false)
		$AnimatedSprite.play("Squashed")
		body.Go_UP()
		speed = 0
		yield(get_tree().create_timer(1), "timeout")
		queue_free()
	else: 
		emit_signal("KnockBack", position.x, position.y, 0.6)
	
func Turn():
	Turn = true
	if Turn == true:
		yield(get_tree().create_timer(1.2 if not Upgrade else .4), "timeout")
		direction = direction *-1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$Checkers/FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x *direction
		$Checkers/BackChecker.set_collision_mask_bit(0, true)
		yield(get_tree().create_timer(.1), "timeout")
		Turn = false

func _on_SidesChecker_body_entered(body):
	if body.get_collision_mask_bit(4) == true:
		emit_signal("KnockBack", position.x, position.y, 0.4)

func _on_BottomChecker_body_entered(body):
	if body.get_collision_mask_bit(4) == true:
		emit_signal("KnockBack", position.x, position.y, 0.4)

func _on_ATTAACK_animation_finished(anim_name):
	Attack = true
	velocity.x = speed*direction*8 if not Upgrade else speed*direction*12
	velocity.y = (randi() % 400 + 100)*-1 if Upgrade else 0
	yield(get_tree().create_timer(1),"timeout")
	Attack = false

func _on_SidesChecker_area_entered(area):
	if area.get_collision_layer_bit(5) == true:
		area.Direction *= -1
		area.set_collision_layer_bit(6, true)
		area.set_collision_mask_bit(0, true)
	
func KnockIT(var POSX):
	Knocked = true
	if position.x > POSX:
		velocity2.x = 400
	elif position.x < POSX:
		velocity2.x = -400
	velocity2.y = -500
	
