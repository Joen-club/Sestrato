extends Area2D
var Direction = 0
var player
var Shooter

func _ready():
	player = get_parent().find_node("Player", true, true)
	Shooter = get_parent().find_node("Shooter", true, true)

func _physics_process(delta):
	if Shooter.cast_to.x > 0:
		Direction = -1
	else: Direction = 1
	position.x += (player.position.x + Shooter.cast_to.x)*delta*0.03*player.acceleration*Direction
	yield(get_tree().create_timer(.3), "timeout")
	queue_free()

func _on_Parry_area_entered(area):
	area.Reflect()
	queue_free()
