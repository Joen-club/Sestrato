extends Control

var MyTime = 0

func _ready():
	$Label2.text = str(MyTime)

func _on_Start_body_entered(body):
	MyTime = 0
	$Timer.start()

func _on_Timer_timeout():
	MyTime += 1
	$Label2.text = str(MyTime)

func _on_Finish_body_entered(body):
	$Timer.stop()
	
func Update():
	$Label2.text = str(MyTime)
