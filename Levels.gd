extends Control

onready var Game_Data = SaveFile.game_data

var PlayerStartingPositions = {
	1: Vector2(188, -835),
	2: Vector2(1, -182),
	3: Vector2(-77, -200),
	4: Vector2(173, -315),
	5: Vector2(-246, -515),
}

func _ready():
	print(Game_Data.Map)
	pass





func _on_Level_pressed(extra_arg_0):
	if extra_arg_0 > Game_Data.MapLevel:
		$AudioStreamPlayer.play()
		return
	get_tree().change_scene("res://Level"+str(extra_arg_0)+".tscn")
	Game_Data.Map = "res://Level"+str(extra_arg_0)+".tscn"
	Game_Data.PlayerPosition = PlayerStartingPositions.get(extra_arg_0)
	get_tree().set_pause(false)
	pass # Replace with function body.


func _on_Back_pressed():
	get_tree().change_scene("res://TitleMenu.tscn")
	pass # Replace with function body.
