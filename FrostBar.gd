extends TextureProgress


func _ready():
	pass

func FrostCount():
	$AnimationPlayer.play("FrostCount")

func FrostReset():
	$AnimationPlayer.play("RESET")
