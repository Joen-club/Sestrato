extends Node

const Save_File = "user://save_file.save"
var game_data = {}
var Uphealth : Upgrade

func _ready():
	
	load_data()

func save_data():
	var file = File.new()
	file.open(Save_File, File.WRITE)
	file.store_var(game_data)
	file.close()

func load_data():
	var file = File.new()
	if not file.file_exists(Save_File):
		game_data = {
			"health": 360,
			"MaxHealth": 360,
			"Level": 1, 
			"UpHealth": [],
			"Coins": 0, #0
			"PlayerPosition": Vector2(743, -387), #Vector2(743, -387),
			"Map": "res://Level0.tscn",#"res://Level0.tscn",
			"RequiredCoins": GameManager.D_Gold,
			"GunRune": false, #false
			"ClimbRune": false, #false
			"ParryRune": false, #false
			"MapLevel": 0, #0
		}
		save_data()
	file.open(Save_File, File.READ)
	game_data = file.get_var()
	file.close()
	pass

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if game_data.MapLevel < GameManager.level:
			game_data.MapLevel = GameManager.level
		self.save_data() # save circle nodes
		get_tree().quit() # default behavior
