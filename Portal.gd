extends Area2D

export var NewPos: Vector2

func _ready():
	pass

func _on_Portal_body_entered(body):
	body.position = NewPos
	pass # Replace with function body.
