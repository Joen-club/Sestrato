extends Area2D

onready var MyTimer = get_parent().get_parent().get_node("HUD/Timer")

func _ready():
	pass


func _on_Target_area_entered(area):
	MyTimer.MyTime -= 3
	MyTimer.Update()
	area.queue_free()
	hide()
	set_collision_mask_bit(5, false)
	yield(get_tree().create_timer(9), "timeout")
	set_collision_mask_bit(5, true)
	show()
	pass # Replace with function body.
