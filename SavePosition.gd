extends Area2D

onready var Game_Data = SaveFile.game_data

func _on_Area2D_body_entered(body):
	print(Game_Data.PlayerPosition)
	Game_Data.PlayerPosition = body.position
	queue_free()
