extends Area2D


func _ready():
	pass


func _on_Area2D_body_entered(body):
	
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	area.queue_free()
	pass # Replace with function body.
