extends Area2D
onready var Game_Data = SaveFile.game_data
var Text


func _ready():
	$AnimationPlayer.play("Rune")
	Text = get_parent().get_node("Label2")
	pass

	
func Showtime():
	Text.show()

func _on_ParryRune_body_entered(body):
	Game_Data.UpHealth.append(self.get_path())
	$AnimationPlayer.play("PickedUp")
	Game_Data.ClimbRune = true
	pass # Replace with function body.
