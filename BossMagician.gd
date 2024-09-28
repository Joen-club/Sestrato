extends KinematicBody2D


var player

export var Flames: PackedScene
export var Magic: PackedScene

var ReloadShoot = false
var ReloadInside = false
var BallsCount = 0
var ReloadFire = false
var Reload = false

var FrostPositions = [2918, 2852, 2780, 2709, 2635, 2574, 2507, 2437, 2359, 2295,
2248, 2178, 2121, 2050, 1982, 1914, 1848, 1791, 1723, 1657, 1619]

var FrostArray = []
var InsideFrostPositions = [Vector2(2466, -1753), Vector2(2533, -1798), 
Vector2(2188, -1800), Vector2(1860, -1784), Vector2(2185, -2019), Vector2(1831, -2005)]

var BulletHellFrost = [3528, 3468, 3368, 3308, 3248, 3178, 3108, 3048, 2988, 2918, 2852, 2780, 2709, 2635, 2574,
2507, 2437, 2359, 2295, 2248, 2178, 2121, 2050, 1982]

var BullerHellFire = [2359, 2295, 2248, 2178, 2121, 2050, 1982, 1914, 1848, 
1791, 1723, 1657, 1619, 1549, 1489, 1429, 1369, 1309, 1249, 1189, 1129]

var Boss_State
enum States {Break, Regular, FromBottom, FromBottomPlus, BulletHell_1, BulletHell_2, BulletHell_3, RegularPlus}

func _ready():
	randomize()
	player = get_parent().get_node("Player")
	Boss_State = States.Break

func _physics_process(delta):
	match Boss_State:
		States.Break:
			General()
			
		States.Regular:
			General()
			RegularShoot()
			
		States.RegularPlus:
			General()
			RegularShoot()
			RegularPlus()
			
		States.FromBottom:
			General()
			BallsFromBottom()
		States.FromBottomPlus:
			BallsInside()
			General()
			BallsFromBottom()
			
		States.BulletHell_1:
			General()
			BulletHell_1()
		
		States.BulletHell_2:
			BulletHell_2()
			General()
			
		States.BulletHell_3:
			BulletHell_1()
			BulletHell_2()
			General()
		
func General():
	$PlayerFollower.cast_to = to_local(player.position)
		
func Defeated():
	$AnimationPlayer.play("Flee")
		
func RegularShoot():
	$AnimatedSprite.play("default")
	if ReloadShoot == true:
		return
	var FrostBall = Magic.instance()
	FrostBall.position = position + Vector2(-35, -10)
	FrostBall.Direction = $PlayerFollower.cast_to.normalized()
	get_tree().current_scene.add_child(FrostBall)
	ReloadShoot = true
	yield(get_tree().create_timer(3),"timeout")
	ReloadShoot = false

func BallsFromBottom():
	if Reload == true:
		return
	var FrostBall = Magic.instance()
	FrostBall.position.y = position.y + 150
	FrostBall.Speed = 750
	FrostBall.position.x = FrostPositions[randi()% FrostPositions.size()]
	FrostBall.Direction = Vector2(0, -1)
	FrostBall.Boss = true
	get_tree().current_scene.add_child(FrostBall)
	Reload = true
	yield(get_tree().create_timer(0.45),"timeout")
	Reload = false

func BallsInside():
	if BallsCount == 4:
		yield(get_tree().create_timer(5),"timeout")
		InsideFrostPositions.clear()
		InsideFrostPositions.append_array(GameManager.OriginalInsideFromBalls)
		BallsCount = 0
		return
	if ReloadInside == true:
		return
	var RandomBalls = randi()% InsideFrostPositions.size()
	var FrostBall2 = Magic.instance()
	FrostBall2.position = InsideFrostPositions[RandomBalls]
	InsideFrostPositions.remove(RandomBalls)
	FrostBall2.Alone = true
	get_tree().current_scene.add_child(FrostBall2)
	BallsCount += 1
	ReloadInside = true
	yield(get_tree().create_timer(2),"timeout")
	ReloadInside = false

func BulletHell_1():
	if Reload == true:
		return
	var FrostBall = Magic.instance()
	FrostBall.position.y = position.y - 750
	FrostBall.Speed = 750
	FrostBall.position.x = BulletHellFrost[randi()% BulletHellFrost.size()]
	FrostBall.Direction = Vector2(-1, 1)
	FrostBall.Boss = true
	get_tree().current_scene.add_child(FrostBall)
	Reload = true
	yield(get_tree().create_timer(0.2),"timeout")
	Reload = false

func BulletHell_2():
	if ReloadFire == true:
		return
	var Fire = Flames.instance()
	Fire.position.y = position.y - 750
	Fire.FlameType = 2
	Fire.speed = 750
	Fire.position.x = BullerHellFire[randi()% BullerHellFire.size()]
	Fire.Direction = Vector2(1, 1)
	get_tree().current_scene.add_child(Fire)
	ReloadFire = true
	yield(get_tree().create_timer(0.3),"timeout")
	ReloadFire = false
	
func RegularPlus():
	if ReloadFire == true:
		return
	var Fire = Flames.instance()
	Fire.FlameType = 2
	Fire.speed = 550
	Fire.position = position + Vector2(-80, 36)
	Fire.Direction = Vector2(-1, 0)
	get_tree().current_scene.add_child(Fire)
	ReloadFire = true
	yield(get_tree().create_timer(1.3),"timeout")
	ReloadFire = false
