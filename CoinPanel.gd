extends Control
var Upgraded = false
onready var HP = $Panel2/ProgressBar
onready var HealthPoints = $Panel2/ProgressBar/Points
onready var MaxHP = $Panel2/ProgressBar/MaxPoints
onready var LVL
onready var Game_Data = SaveFile.game_data
var hud

func _ready():

#	HP.value = Game_Data.health
	HealthPoints.text = str(HP.value)
	MaxHP.text = str(HP.max_value)
	pass
	

#func Hplow():
#	$Panel2/TextureProgress.value -= 40
#	if $Panel2/TextureProgress.value == $Panel2/TextureProgress.min_value:
#		get_tree().reload_current_scene()
#
#func Upgrade1():
#	$Panel2/TextureProgress.texture_under = load("res://HUD/2EmptyBar.png")
#	$Panel2/TextureProgress.texture_progress = load("res://HUD/2HealthBar.png")
#	$Panel2/TextureProgress.max_value += 120
#	$Panel2/TextureProgress.value += $Panel2/TextureProgress.max_value
#	Upgraded = true
#
#func Upgrade2():
#	if Upgraded == true or GameManager.level ==2 :
#		$Panel2/TextureProgress.texture_under = load("res://HUD/3EmptyBar.png")
#		$Panel2/TextureProgress.texture_progress = load("res://HUD/3HealthBar.png")
#		$Panel2/TextureProgress.texture_over = load("res://HUD/3EmptyBar.png")
#		$Panel2/TextureProgress.max_value += 120
#		$Panel2/TextureProgress.value += $Panel2/TextureProgress.max_value
#	else:
#		Upgrade1()




