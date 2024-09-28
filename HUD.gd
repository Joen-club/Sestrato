extends CanvasLayer

var Coins: int

onready var Game_Data = SaveFile.game_data

func _ready():
	Coins = Game_Data.Coins
	$CoinPanel/AmountOfCoins.text = str(Coins)

func _on_Coin_collected():
	Game_Data.Coins += 1
	_ready()



