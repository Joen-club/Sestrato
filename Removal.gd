extends Area2D
onready var items = get_parent().get_node("SecretZone")

func _ready():
	pass


func _on_Removal_body_entered(body):
	items.queue_free()
	queue_free()
	pass # Replace with function body.
