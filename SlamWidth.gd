extends Area2D

var player

func _ready():
	player = get_parent().find_node("Player", true, true)

func _on_SlamWidth_body_entered(body):
	body.KnockIT(player.position.x)

