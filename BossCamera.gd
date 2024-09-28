extends Camera2D


func _ready():
	current = false
	pass


func _on_Portal_body_entered(body):
	current = true
	pass # Replace with function body.
