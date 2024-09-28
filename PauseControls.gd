extends Control
signal Go_back
onready var PauseMod = get_parent()

func _unhandled_input(event):
	if event.is_action_released("Pause") and PauseMod.Visibility == true:
		emit_signal("Go_back")

func _on_Back_pressed():
	emit_signal("Go_back")
