extends Area2D
export var Direction = Vector2.ZERO
export var Speed: float
var FrostFrost = false
var player
export var Alone = false
export var Boss = false


func _ready():
	if Alone:
		$Timer.start()
	player = get_parent().find_node("Player", true, true)
	connect("area_entered", self, "_on_area_entered")
	if Alone: 
		$AnimationPlayer.play("Rotate2")
		Speed = 60
	elif not Alone:
		if Boss:
			Speed = 750
			modulate = "ffffff"
			return
		$AnimationPlayer.play("Rotate")
		$AnimationPlayer2.play("ForSpeed")
		
func EstablishDirection():
	if Boss:
		return
	$RayCast2D.cast_to = to_local(player.position)
	Direction = $RayCast2D.cast_to.normalized()
	
func _physics_process(delta):
	if Alone: 
		var k = Vector2(20, -20)
		$RayCast2D.cast_to = to_local(k)
		Direction = $RayCast2D.cast_to.normalized()
	position += Direction * Speed*delta

func _on_area_entered(hitbox: Shield):
	if hitbox == null:
		return
	
	if has_method("Absorb"):
		Absorb()
		hitbox.Stun(6)

func Absorb():
	pass
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_FrostBall_body_entered(body):
	body.Freeze()
	FrostFrost = true
	queue_free()
	pass # Replace with function body.


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
