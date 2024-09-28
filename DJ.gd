extends Area2D

var Used = false
var player

func _ready():
	$AnimationPlayer.play("Boink")

func _physics_process(delta):
	if Used == true and Input.is_action_pressed("jump"):
		player.NearDJ = true
		DJ()

func _on_DJ_body_entered(body):
	player = body
	Used = true
	body.JumpWasPressed = true


func DJ():
	if Used == true:
		player.UnLimitDash()
		Used = false
	hide()
	$CollisionShape2D.disabled = true
	yield(get_tree().create_timer(2),"timeout")
	show()
	$CollisionShape2D.disabled = false


func _on_DJ_body_exited(body):
	Used = false
	pass # Replace with function body.
