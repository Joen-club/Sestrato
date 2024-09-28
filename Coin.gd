extends Area2D

signal Coin_collected
onready var UpCoin: Upgrade
onready var Game_Data = SaveFile.game_data

func _on_Coin_body_entered(body):
	add_to_group("Collected")
	$AnimationPlayer.play("Coinbounce")
	emit_signal("Coin_collected")
	set_collision_mask_bit(0, false)
	Game_Data.UpHealth.append(self.get_path())

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

