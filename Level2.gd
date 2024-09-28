extends Node2D

onready var Game_Data = SaveFile.game_data
var RequiredCoins = 9
var Level: int = 2
onready var player = find_node("Player", true, true)
onready var HUD = find_node("CoinPanel", true, true)

func _ready():
#	Game_Data.ClimbRune = false
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


func _on_FallZone2_body_entered(body):
	HUD.Hplow(0.3)
	pass # Replace with function body.


func _on_Player_DoorOpened():
	Game_Data.PlayerPosition = Vector2(-77, -200)
	print(Game_Data.PlayerPosition)
	pass # Replace with function body.
