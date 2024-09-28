extends Area2D
onready var Game_Data = SaveFile.game_data
var Text
var Block
signal Now

func _ready():
	Block = get_parent().get_node("Block")
	$AnimationPlayer.play("Rune")
	Text = get_parent().get_node("Node2D/Control/Label2-5")
	pass


func _on_GunRune_body_entered(body):
	Game_Data.UpHealth.append(self.get_path())
	$AnimationPlayer.play("PickedUp")
	Game_Data.GunRune = true
	pass # Replace with function body.
	
func Showtime():
	emit_signal("Now")
	Block.queue_free()
	Text.show()
