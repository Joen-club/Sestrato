extends Node2D

onready var Game_Data = SaveFile.game_data
var RequiredCoins = 12
var Level = 3
onready var player = find_node("Player", true, true)
onready var HUD = find_node("CoinPanel", true, true)

func _ready():
	Game_Data.Map = "res://Level"+str(Level)+".tscn"
	GameManager.level = Level
	GameManager.D_Gold = RequiredCoins

func _on_FallZone_body_entered(body):
	if body.get_collision_layer_bit(4):
		body.queue_free()
	elif body.is_in_group("Magician"):
			body.Return()
	elif body.get_collision_layer_bit(0):
		player.Fell()
		HUD.Hplow(0.4)


func _on_Player_DoorOpened():
	Game_Data.PlayerPosition = Vector2(173, -315)
	pass # Replace with function body.


func _on_FallZone2_body_entered(body):
	body.position = Vector2(-3252.541, -3771.085)
	HUD.Hplow(0.4)
	pass # Replace with function body.
