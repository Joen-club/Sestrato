extends Control

onready var player = get_parent().get_parent().find_node("Player", true, true)
onready var Controls = get_node("Control")
onready var Game_Data = SaveFile.game_data
var is_paused = false setget set_is_paused 
var Visibility = false
onready var HPBAR = get_parent().get_node("CoinPanel")

func _ready():
	pass
	

func _unhandled_input(event):
	if event.is_action_pressed("Pause") and $BackGround.visible:
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused


func _on_Quit_pressed():
	if Game_Data.MapLevel < GameManager.level:
		Game_Data.MapLevel = GameManager.level
	SaveFile.save_data()
	get_tree().quit()


func _on_Controls_pressed():
	$BackGround.visible = !$BackGround.visible
	Visibility = !Visibility
	Controls.show()



func _on_Resume_pressed():
	self.is_paused = false


func _on_Control_Go_back():
	Visibility = !Visibility
	$BackGround.visible = !$BackGround.visible
	Controls.hide()


func _on_Restart_pressed():
	HPBAR.Hplow(700)
	self.is_paused = false
	get_parent().get_parent().get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_Main_menu_pressed():
	get_tree().change_scene("res://TitleMenu.tscn")
	pass # Replace with function body.
