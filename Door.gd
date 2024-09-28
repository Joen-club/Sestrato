extends Area2D

onready var Game_Data = SaveFile.game_data
var ClosetoDoor = false
var Level

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	$Control/Label.text = "x"+str(GameManager.D_Gold)

func _on_Door_body_entered(body):
	body.Door_Door()
	
func _on_Door_body_exited(body):
	body.Door_NoDoor()

