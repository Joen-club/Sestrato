extends TextureProgress

onready var Game_Data = SaveFile.game_data

func _ready():
	show() if Game_Data.GunRune else hide()
	pass

func Now():
	show()

func ShootCount():
	$AnimationPlayer.play("ShootCount")
