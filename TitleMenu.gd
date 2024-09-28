extends Control
onready var PlayGame = get_node("Panel/TextureRect/PlayGame")
onready var Game_Data = SaveFile.game_data

func _ready():
	print(Game_Data.MapLevel)
	$AnimationPlayer.play("Appear")
	get_tree().set_pause(true)
	PlayGame.connect("pressed", self, "Play")
	
func Play():
	get_tree().change_scene(Game_Data.Map)
	get_tree().set_pause(false)
	queue_free()
	
func _on_About_Game_pressed():
	get_tree().change_scene("res://Controls.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Levels_pressed():
	get_tree().change_scene("res://Levels.tscn")
