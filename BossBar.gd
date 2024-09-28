extends ProgressBar
signal Boss_Is_Dead

func _ready():
	visible = false
	value = 100
	pass


func _on_Area2D2_area_entered(area):
	area.queue_free()
	value -= 5
	pass # Replace with function body.


func _on_BossBar_value_changed(value):
	if value <= 0:
		emit_signal("Boss_Is_Dead")
	pass # Replace with function body.


func _on_Portal_body_entered(body):
	visible = true
	pass # Replace with function body.
