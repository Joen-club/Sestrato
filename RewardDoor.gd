extends Area2D

onready var YourTime = get_parent().get_node("Node2D/HUD/Timer")
onready var player = get_parent().get_node("Node2D/Player") 
export var ReqTime: float
export var NewPos: Vector2
export var Restart = false

func _ready():
	$Label2.text = str(ReqTime) + " sec" if ReqTime != 2000 else "Restart"
	pass

func _on_Finish_body_entered(body):
	if YourTime.MyTime <= ReqTime:
		$Sprite.texture = load("res://Doors/doorClosed.png") if ReqTime != 2000 else load("res://Doors/doorOpen.png")
		body._GainReward(NewPos)#Choose position
	pass # Replace with function body.




func _on_RewardDoor_body_entered(body):
	player.NewPos = NewPos
	player.NearDoor = true if YourTime.MyTime <= ReqTime else false
	pass # Replace with function body.


func _on_RewardDoor_body_exited(body):
	player.NearDoor = false
	pass # Replace with function body.
