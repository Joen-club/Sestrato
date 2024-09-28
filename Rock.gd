extends RigidBody2D

var player
var Direction = Vector2.RIGHT
var Speed = 200
var Gravity = 700

func _physics_process(delta):
	Direction = $RayCast2D.cast_to.normalized()
	position += Direction*Speed*delta
	position.y += Gravity*delta



func _ready():
	player = get_parent().find_node("Player", true, true)
	
	var RandPos = randi() % 20 + 1
	position.y = player.position.y
	if RandPos >= 10:
		position.x = player.position.x - (randi() % 200 + 1) - 5
		linear_velocity.x += -350
		$RayCast2D.cast_to.x = -90
	else:
		position.x = player.position.x + (randi() % 200 +1) + 5
		linear_velocity.x += 350
		$RayCast2D.cast_to.x = 90
	yield(get_tree().create_timer(2.5), "timeout")
	queue_free()

