extends TextureProgress


func _ready():
	pass

func DashCount():
	$AnimationPlayer.play("DashCount")

func DashReset():
	$AnimationPlayer.play("RESET")
	value = 100
