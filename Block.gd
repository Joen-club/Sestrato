extends StaticBody2D

onready var Game_Data = SaveFile.game_data

func _ready():
	if Game_Data.GunRune: 
		queue_free()
	pass
