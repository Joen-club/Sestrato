extends Area2D

onready var player = get_parent().find_node("Player", true, true)
var Direction = Vector2.RIGHT
export var speed: float


func _ready():
	$AnimationPlayer.play("ForSpeed")
	pass

func _physics_process(delta):
	Direction = player.position
	position += Direction*speed*delta


