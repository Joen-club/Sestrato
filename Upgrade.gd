extends Area2D

class_name Upgrade


var player
export var Upgrade_ids = []
onready var Game_Data = SaveFile.game_data

func _ready():
	Upgrade_ids = Game_Data.UpHealth if Game_Data.UpHealth != null else []
	for x in Upgrade_ids:
		var item = get_node_or_null(x)
		if item:
#			print(item)
			item.queue_free()
	player = get_parent().find_node("Player", true, true)
	$AnimationPlayer.play("Upgrade")
	pass


func _on_Upgrade_body_entered(body):
	add_to_group("Collected")
	Game_Data.UpHealth.append(self.get_path())
	$AnimationPlayer.play("PickedUp")

func Showtime():
		Game_Data.Level += 1
		player.Upgrade()
