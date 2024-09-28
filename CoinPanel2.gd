extends Control
var Upgraded = false
onready var HP = $Panel2/TextureProgress
onready var LVL = $Panel2/TextureProgress.texture_progress
onready var LVLV = $Panel2/TextureProgress.texture_under


export onready var Mapl = 0

onready var Game_Data = SaveFile.game_data
var hud

func _ready():
	Update_health()
	$Panel2/TextureProgress.texture_progress = load("res://HUD/"+str(Game_Data.Level)+"HealthBar.png")
	$Panel2/TextureProgress.texture_under = load ("res://HUD/"+str(Game_Data.Level)+"EmptyBar.png")
	
	HP.value = Game_Data.health
	HP.max_value = Game_Data.MaxHealth

func Hplow(var Dmg):
	Game_Data.health -= 60*Dmg if Game_Data.health > 0 else 0
	Update_health()
	if Game_Data.health <= 0:
		Game_Data.health = Game_Data.MaxHealth
		yield(get_tree().create_timer(.3),"timeout")
		get_tree().change_scene(Game_Data.Map)
		

func Reload_Map():
	if Mapl == 1:
		get_tree().change_scene("res://Main.tscn")

func Upgrade1():
	$Panel2/TextureProgress.texture_under = load("res://HUD/2EmptyBar.png")
	$Panel2/TextureProgress.texture_progress = load("res://HUD/2HealthBar.png")
	$Panel2/TextureProgress.max_value += 120
	$Panel2/TextureProgress.value += $Panel2/TextureProgress.max_value
	Game_Data.health = HP.value
	Game_Data.MaxHealth = HP.max_value
	Upgraded = true

func Upgrade2():
	if Upgraded == true or Game_Data.Level == 3:
		$Panel2/TextureProgress.texture_under = load("res://HUD/3EmptyBar.png")
		$Panel2/TextureProgress.texture_progress = load("res://HUD/3HealthBar.png")
		$Panel2/TextureProgress.texture_over = load("res://HUD/3EmptyBar.png")
		$Panel2/TextureProgress.max_value += 120
		$Panel2/TextureProgress.value += $Panel2/TextureProgress.max_value
		Game_Data.health = HP.value
		Game_Data.MaxHealth = HP.max_value
	else:
		Upgrade1()

func Update_health():
	HP.value = Game_Data.health



func _on_GunRune_Now():
	$ShootBar.Now()
	pass # Replace with function body.
