extends Node2D

var Level = 0
var RequiredCoins = 3
var player
onready var HUD 
onready var MyPath = self.get_node_or_null(self.get_path())
onready var Game_Data = SaveFile.game_data

func _ready():
	GameManager.level = Level
	GameManager.D_Gold = RequiredCoins
	player = find_node("Player", true, true)
	HUD = find_node("CoinPanel", true, true)
	HUD.Mapl = 1

func _on_FallZone_body_entered(body):
	
	if body.get_collision_layer_bit(4) == true:
		body.queue_free()
	elif body.is_in_group("Magician"):
			body.Return()
	else: 
		player.Fell()
#		player.position = player.posRemembered
		HUD.Hplow(0.5)
		

func _on_Player_DoorOpened():
	Game_Data.PlayerPosition = Vector2(191, -823)
	pass # Replace with function body.
