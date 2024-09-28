extends Node2D

onready var Game_Data = SaveFile.game_data
var Level = 5
onready var player = find_node("Player", true, true)
onready var HUD = find_node("CoinPanel", true, true)

func _ready():
	Game_Data.Map = "res://Level"+str(Level)+".tscn"
	Game_Data.health = Game_Data.MaxHealth
	print(player.position)
	GameManager.level = Level

func _on_FallZone_body_entered(body):
		player.Fell()
		HUD.Hplow(0.4)

#func _on_Player_DoorOpened():
#	Game_Data.PlayerPosition = Vector2(173, -315)

func Win():
	get_tree().change_scene("res://Credits.tscn")
