extends Area2D
var SurvMode = false
var Time_to_Live = 75
onready var SurvTimer = $Timer
onready var Disappear = get_parent().get_node("Node2D/Need to disappear")
onready var Game_Data = SaveFile.game_data

func _ready():
	$Control/Timer.text = str(Time_to_Live)
	
	pass


func _on_Survive_body_entered(body):
	if SurvMode:
		return
	else:
		
		SurvMode = true
		$Control/Label2.show()
		yield(get_tree().create_timer(3), "timeout")
		$Control/Label2.hide()

		SurvTimer.start()
		
		
	pass # Replace with function body.


func _on_Timer_timeout():
	Time_to_Live -= 1
	$Control/Timer.text = str(Time_to_Live)
	if Time_to_Live == 0:
		Game_Data.UpHealth.append(Disappear.get_path())
		Game_Data.UpHealth.append($Survival.get_path())
		$Timer.stop()
		Disappear.queue_free()
		$Survival.queue_free()
		$Control/Label2.text = "Good Job"
	pass # Replace with function body.


func _on_Portal_body_entered(body):
	
	yield(get_tree().create_timer(.2),"timeout")
	queue_free()
	pass # Replace with function body.


func _on_Reset_body_entered(body):
	Time_to_Live = 75
	SurvMode = false
	pass # Replace with function body.

