extends KinematicBody2D
### Костыли пишутся на русском для удобства
#############################################################################
#############################################################################
#Variables for speed, gravity:
export var Gravity = GameManager.D_Gravity
export var velocity = GameManager.D_velocity
export var currentSpeed = GameManager.D_currentSpeed
export var acceleration = GameManager.D_acceleration
var MoveWasPressed = false
							#to change velocity in the more easier way
#############################################################################
#############################################################################
#Jump Variables:
export var JumpPower = GameManager.D_JumpPower
var SuperJump = GameManager.D_SuperJump
var JumpScale = GameManager.D_JumpScale #See the "LetsGO" Function. If it's = 3, you can do SuperJump
export var state = GameManager.D_state      #state(1,2) is a variable that 
export var state1 = GameManager.D_state1   #is being used to maitain the height of the jump
var state2 = GameManager.D_state2
export var JumpWasPressed = GameManager.D_JumpWasPressed
var ClimbCheck = false
var DelayedJump = false
#############################################################################
#############################################################################
#SLAM:
var SlamPower = GameManager.D_SlamPower
export var Is_Slam = false
export var CheckSlam = false
#############################################################################
#############################################################################
#Dash variables (see "Dash" Function):
var DashState = GameManager.D_DashState   #if this isn't equal to 0 you're not allowed to Dash
var DashPower = GameManager.D_DashPower
#############################################################################
#############################################################################
#MONEY
var Gold = GameManager.D_Gold
#############################################################################
#############################################################################
#Emenies' variables
export var KnockBack = false #KnockBack disables all or almost all kind of movement
#############################################################################
#############################################################################
#Timers
var FrostTimer = Timer.new()
var DashTimer = Timer.new()
var VertTimer = Timer.new()
#############################################################################
#############################################################################
var reload = false


var Ladder = false

enum States {AIR, FLOOR, WALL, KNOCKED, FROZEN, LADDER}
export var MyState = States.AIR

onready var Game_Data = SaveFile.game_data

var NearDJ = false

var CloseToDoor: bool
var Frozen = false
export var UnFrozen = false #if true, it doesn't allow you to get frozen

onready var DashBar = get_parent().get_node("HUD/CoinPanel/DashBar")
onready var FrostBar = get_parent().get_node("HUD/CoinPanel/FrostBar")
onready var ShootBar = get_parent().get_node("HUD/CoinPanel/ShootBar")

var posRemembered 
var Door
var HUD
export var Projectile: PackedScene
export var PARRY: PackedScene
export var Slam: PackedScene
export var Rocks: PackedScene

signal DoorOpened

func _ready():
	setupTimers()
	HUD = get_parent().find_node("CoinPanel", true, true)
	position = Game_Data.PlayerPosition
	posRemembered = position
	Door = get_parent().get_node("Door/AudioStreamPlayer2D")
	
func _physics_process(delta):
#	print(JumpWasPressed)
	match MyState:
		States.AIR:
			Movement(delta)
			JumpLogic(delta)
			#Dash. Whenever you're midair, press double left/double right
			#to do dash in the particular direction
			Dash()
			SLAM()
			Shoot()
			Parry()
			GeneralCorrection()
			AirCorrection()
			Attach()
			if is_on_floor():
				MyState = States.FLOOR
				continue
			elif On_Ladder():
				MyState = States.LADDER
				continue
				
		States.FLOOR:
			Movement(delta)
			JumpLogic(delta)
#			_GainReward(NewPos)
			Shoot()
			Parry()
			_Run()
			GeneralCorrection()
			CorrectMe()
			if not is_on_floor() and not $Slam.is_playing():
				MyState = States.AIR
				continue
			elif On_Ladder():
				MyState = States.LADDER
				continue
				
		States.WALL:
			Movement(delta)
			WallClimbing(delta) if Game_Data.ClimbRune else WallJump(delta)
			GeneralCorrection()
			Anti_Attach()
			if is_on_floor():
				MyState = States.FLOOR
				continue
				
			
		States.KNOCKED:
			
			KnockOUT(delta)
			if is_on_floor() and KnockBack == false:
				MyState = States.FLOOR
				continue
			if is_on_wall():
				velocity.x = 0
		
		States.LADDER:
			LadderMoves(delta)
			$Sprite.play("Climb")
			if is_on_floor():
				Input.action_release("down")
				MyState = States.FLOOR
				continue
			elif not Ladder:
				MyState = States.AIR
				continue
		
		States.FROZEN:
			$AnimationPlayer2.play("Unfreeze")
			velocity.x = 0
			KnockOUT(delta)
			self.modulate = "25b0bd"
			if KnockBack == true:
				self.modulate = "ffffff"
				MyState = States.KNOCKED
				UnFrozen = false
				continue
			
func LadderMoves(delta):
	if Input.is_action_pressed("down") or  Input.is_action_pressed("up") or  Input.is_action_pressed("left") or  Input.is_action_pressed("right"):
		$Sprite.play("Climb")
	else: $Sprite.stop()
	if Input.is_action_pressed("down"):
		velocity.y = 300
	elif Input.is_action_pressed("up"):
		velocity.y = -300
	else: velocity.y = 0
	if Input.is_action_pressed("right"):
		$Sprite.flip_h = false
		velocity.x = 120
	elif Input.is_action_pressed("left"):
		$Sprite.flip_h = true
		velocity.x = -120
	else: velocity.x = 0
		
	if Input.is_action_just_pressed("jump"):
		Ladder = false
		velocity.y = JumpPower*1.3
		velocity.x = -1500 if $Sprite.flip_h else 1500
	move_and_slide(velocity, Vector2.UP)

func KnockOUT(delta):
	$Sprite.play("Knocked_Frozen")
	Gravity = GameManager.D_Gravity
	if not is_on_floor():
		velocity.y += Gravity*delta
	move_and_slide(velocity, Vector2.UP)
	$Slam.play("RESET")

func Movement(delta): #This function includes basic walks 
					  #and acceleration, jump, dash
	if Input.is_action_just_pressed("Interaction") and CloseToDoor == true:
		if Game_Data.Coins >= GameManager.D_Gold:
			emit_signal("DoorOpened")
			Game_Data.health = Game_Data.MaxHealth
			get_tree().change_scene("res://Level"+str((GameManager.level+1))+".tscn")
			Game_Data.Map = "res://Level"+str((GameManager.level+1))+".tscn"
		else:
			Door.play()
					
	if Input.is_action_pressed("left"):
		MoveWasPressed = true
		velocity.x += (-200 + currentSpeed)*acceleration*delta
		if (-200 + currentSpeed) < -200:
			currentSpeed = -80
		  #Фактически, я был вынужен использовать (200 + currentSpeed)
		  #как костыль для работы абилки лазить по стенам
		$Sprite.flip_h = true
		
	elif Input.is_action_pressed("right"):
		MoveWasPressed = true
		velocity.x += (200 + currentSpeed)*acceleration*delta
		if (200 + currentSpeed) > 200: #Отскакивая от стены, некоторое время
			currentSpeed = 80        #Скорость перса будет чуть выше дефолтной
									 #(Без этих строк она чересчру высокая)
									 #Благодаря этим строкам, но !Костыль!
		$Sprite.flip_h = false

	move_and_slide(velocity, Vector2.UP, false, 4, 0.785, false) 
	#Method to move the character
	#Vector2.UP determines whether you're on the floor or midair
	velocity.x = lerp(velocity.x, 0, 0.2)
	Gravity = GameManager.D_Gravity
	
	
	"""ВСЕ ЭТИ СТРОКИ -- один большой костыль. ТРЕБУЕТ ДОРАБОТКИ"""
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("Spikes"):
			if $FloorDetecter.position.y < collision.collider.position.y:
				if ($FloorDetecter.position.x)*-1 < collision.collider.position.x:
					_on_Enemy_KnockBack(20000, 20000, 0.5)
				else:
					_on_Enemy_KnockBack(-20000, 20000, 0.5)
			else:
				if ($FloorDetecter.position.x)*-1 < collision.collider.position.x:
					_on_Enemy_KnockBack(20000, -20000, 0.5)
				else:
					_on_Enemy_KnockBack(-20000, -20000, 0.5)
		if collision.collider.is_in_group("Plats"):
			if Is_Slam == true and is_on_floor() and CheckSlam == true:
				_End_Slam()
			"""ВСЕ ЭТИ СТРОКИ -- один большой костыль. ТРЕБУЕТ ДОРАБОТКИ"""

func Anti_Attach():
	if not $Shooter.is_colliding():
		MyState = States.AIR

func DelayJump():
	yield(get_tree().create_timer(.2),"timeout")
	DelayedJump = false

func Attach():
	if Input.is_action_just_pressed("jump"):
		DelayedJump = true
		DelayJump()
	if $Shooter.is_colliding() and JumpWasPressed == false:
		ClimbCheck = true if $Shooter.cast_to.x > 0 else false
		velocity.x += $Shooter.cast_to.x*4
		MyState = States.WALL

func SLAM():
	if Input.is_action_pressed("down"):
		if Input.is_action_just_pressed("jump") and Is_Slam == false:
			_Start_Slam()

func WallJump(delta):
	velocity.y += Gravity*delta
	$Sprite.play("On wall")
	state = state1
	velocity.x += 10 if not $Sprite.flip_h else -10
	Gravity = 1000
	if DelayedJump == true:
		Jump()
	if Input.is_action_just_pressed("jump"):
		Jump()
	if not Input.is_action_pressed("jump"):
		JumpWasPressed = true 

func WallClimbing(delta):
	$Sprite.play("On wall")
	if not Input.is_action_pressed("jump"):
		JumpWasPressed = true 
	state = state1
	velocity.x += 0
	Gravity = 70
	if $Sprite.flip_h == false: #DEBUG. I've got no freaking clue why I'm 
		velocity.x += 10 #falling after a certain length of time
	 #if i'm facing the right side SOO PISSED OFF
	if DelayedJump == true:
		Jump()
	
	if Input.is_action_pressed("up"):
		velocity.y = -200*4*acceleration*delta
		if Input.is_action_just_pressed("jump") and $Shooter.is_colliding():
			JumpWasPressed = false
			Jump()
	elif Input.is_action_just_pressed("jump"):
		JumpWasPressed = false
		Jump()
	elif Input.is_action_pressed("down"):
		velocity.y = 200*4*acceleration*delta
	elif Input.is_action_just_pressed("jump"):
		DashState = 0 #If you press Dash on the wall, you'll likely
		#Won't move at all, so to avoid a waste of the ability, you'll
		#get reset of the dash immediately
	else: 
		velocity.y = lerp(velocity.y, 0, 0.35) #You can jump right after you've pressed any 
		#direction button

func Jump(): #Jump for the function right above
	if (Input.is_action_pressed("left") and ClimbCheck) or (Input.is_action_pressed("right") and not ClimbCheck):
		MyState = States.AIR
		velocity.y = JumpPower*2
		return
	JumpWasPressed = false
	if DelayedJump:
		JumpWasPressed = false
		DelayedJump = false
	if Input.is_action_just_pressed("jump") or DelayedJump:
		MyState = States.AIR
		JumpWasPressed = false
		velocity.y = JumpPower
		VertTimer.start(0.5) #Таймер для возвращения скорости
		if not ClimbCheck:
				velocity.x = 5000
				currentSpeed += 240 
			#Теперь, когда ты спрыгиваешь с "липкой стены"
			#Твоя скорость в направлении стены сильно снижена
			#Нельзя залезть обратно на стену без Dash'a
			#Нужна доработка, ибо используется слишком много
			#Костылей и ненужных строк кода, также 
			#Уменьшается читаемость и гибкость кода
		elif ClimbCheck:
				velocity.x = -5000
				currentSpeed -= 240

func JumpLogic(delta): #Basically when you press "jump", 
#game check whether you're on the floor, then if you are, it increases 
#the "state" var to limit the timelength of the jump and you actually jump
	if MyState == States.AIR and Is_Slam == false: #Gravity formula + forbidden to jump midair
		velocity.y += Gravity*delta
		$Sprite.play("Jump")
		
		if Input.is_action_pressed("jump") and JumpWasPressed == true:
			velocity.x *= 2.6        #This thing is only for DJs
			velocity.y = JumpPower*2 #You can either hold space and do small jumps
									 #or press it at the right timing and get higher
									 #jump and horizontal boost
			JumpWasPressed = false
	elif MyState == States.FLOOR and Is_Slam == false:
		state = 0 
		velocity.y = 25

	if Input.is_action_pressed("jump"):
		state = lerp(state, state1, 0.85)#This code will limit the time 
										 #you're allowed to increase height 


	if Input.is_action_pressed("jump") and state < state1:
		velocity.y = JumpPower
		
	
	if Input.is_action_just_released("jump"): #If this code wouldn't exists, 
			 #the player could do Double jump

		JumpPower = GameManager.D_JumpPower #Otherwise it just saves the number; in other   
		JumpScale = GameManager.D_JumpScale         #words You could do a SuperJump after two jumps  
							  #in a row and you could do multiple superjumps
		state = state1 #To avoid unforeseen double jumps/multiple jumps

	if state != 0: #Whenever you're midair, state variable will never
  #be equal to 0, so it can enable the "Jump" animation no clue why this  
  #thing doesn't work with velocity.y != 0. The animation just buggs out
		$Sprite.play("Jump")
		
func setupTimers(): #Timers
	FrostTimer.connect("timeout", self, "Unfreeze")
	FrostTimer.set_one_shot(true)
	add_child(FrostTimer)
	
	DashTimer.connect("timeout", self,"UnDash")
	DashTimer.set_one_shot(true)
	add_child(DashTimer)
	
	VertTimer.connect("timeout", self, "CorrectSpeed")
	VertTimer.set_one_shot(true)
	add_child(VertTimer)
	
func CorrectMe(): #Whenever you get hit by an enemy you get stun until
	#You land on a floor. Stun is defind by the variable KnockBack
	#This function executes multiple correct things
	
	if KnockBack == true and not $Blink.is_playing(): 
		yield(get_tree().create_timer(.1), "timeout")
		acceleration = GameManager.D_acceleration

func GeneralCorrection():
	#The function contains all the "Behind the scenes" stuff
	if $Sprite.flip_h == true:
		$Shield.position.x = -40
		$Shield.rotation_degrees = 0
		$Shield.flip_v = false
		$Shooter.cast_to.x = -60
		$FloorDetecter.position.x = -60
		$FloorDetecter2.position.x = 60
	else:
		$Shooter.cast_to.x = 60
		$Shield.rotation_degrees = 180
		$Shield.flip_v = true
		$Shield.position.x = 40
		$FloorDetecter.position.x = 60
		$FloorDetecter2.position.x = -60

func AirCorrection():
	#Assigned to the AnimationPlayer. Disabled the ability to jump MidAir
	if JumpWasPressed == true and not $AllowingToJump.is_playing():
		$AllowingToJump.play("JumpWasPressed")
	if not $AllowingToJump.is_playing() and state == 0:
		$AllowingToJump.play("State_0")

func CorrectSpeed(): #Часть рудиментарной абилки лазить по стенам
	currentSpeed = GameManager.D_currentSpeed 
	#Теперь дефолт скорость всегда = 0 !(ВРЕМЕННО)!

func Go_UP():
	if Is_Slam == false:
		MyState = States.AIR if MyState != States.FROZEN else States.FROZEN
		#In case you've hit the top of an enemy (right now it equals to killing him)
#		KnockBack = true #This code is necessary because game considers you're 
		#on the floor when you hit the top, so it doesn't allow you to increase
		#Your velocity.y 
		#Technically it doesn't affect the gameplay at all (I think) but still
		#Not a good excuse for me
		velocity.y = JumpPower
		yield(get_tree().create_timer(.01), "timeout")
		KnockBack = false

func Dash(): #Function that provides you to dash
	if Input.is_action_just_pressed("Dash") and DashState == 0:
		DashBar.value = 0 #A part of the cooldown
		DashBar.DashCount() #A part of the cooldown
		if $Sprite.flip_h == true:
			velocity.x = -DashPower.x
			velocity.y += DashPower.y #Technically Dash allows you to go up a bit
							  #but IMO it's a better option to avoid 
							  #frustrating situations with gravity		
		elif $Sprite.flip_h == false:
			velocity.x = DashPower.x
			velocity.y += DashPower.y
		DashState += 1
		DashTimer.start(3) #A part of the cooldown
		
func UnLimitDash(): #Use two DJ things to get extra dash: see DJ script
	if DashState > 0:
		DashState -= 0.5
		if DashState == 0:
			DashBar.DashReset()

func UnDash(): #Cooldown
	DashState = 0

func _on_Enemy_KnockBack(var posx, var posy, var DMG): #Those variables determine your
	#direction in relation to a enemy by defining his position.x(posx) and 
	#position.y (posy) and compairing it to your position.x and .y
	if KnockBack == true or $Blink.is_playing():
		return
	$Hit.play()
	FrostBar.FrostReset() 
	KnockBack = true 
	MyState = States.KNOCKED
	if KnockBack == true:
		$Blink.play("Blink")
		HUD.Hplow(DMG)
		if position.x < posx: #You're standing further to the left
			velocity.x = -500
		elif position.x > posx: #Standing further to the right
			velocity.x = 500
		if position.y > posy: #Standing below
			velocity.y = 200
			$CollisionShape2D.set_deferred("disabled", true) # To aviod collision
			yield(get_tree().create_timer(.1),"timeout") #between player and enemy
			$CollisionShape2D.set_deferred("disabled", false) #Otherwise enemy  
			#sticks to the head of a player
		else: velocity.y += -750

	
func KnockUp(): #In case you've hit the bottom of the enemy
	velocity.y = 0

func _Run(): #Needs to be renamed as I've deleted the Run ability
	#Raycasts detect your last position and, if you are not on spikes, teleport 
	#You back in case you've fallen
	if $FloorDetecter.is_colliding() and $FloorDetecter2.is_colliding(): 
		if not $SpikeDetecter.is_colliding(): 
			posRemembered = position
		
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		$Sprite.play("Walk")
	else:
		$Sprite.play("Idle")
			
	if Input.is_action_pressed("down") and is_on_floor(): #allows to go under
		position.y += 5                                   #the platforms 

func Shoot():
	if Input.is_action_pressed("SHoot") and Game_Data.GunRune == true and reload != true:
		$Shoot.play() #Sound
		reload = true #CoolDown
		ShootBar.ShootCount() #ShootBar CoolDown
		
		var PJ = Projectile.instance()
		PJ.position = position + $Shooter.position
		PJ.Direction = ($Shooter.cast_to).normalized()
		get_tree().current_scene.add_child(PJ)
		
		yield(get_tree().create_timer(1), "timeout")
		reload = false

func Parry():
	#You need to gain a Rune to be able to parry bullets.
	if Input.is_action_just_pressed("Parry") and not Frozen and Game_Data.ParryRune:
		$AnimationPlayer.play("Parry")

func _on_Shield2_area_entered(area):
	#Changes bullet layer to player's projectile layer
	area.set_collision_layer_bit(5, true)
	$AnimationPlayer.play("RESET")

func _Start_Slam():
	$AnimationPlayer2.stop()
	$Slam.play("StartSlam")
	velocity = Vector2.ZERO
	Is_Slam = true
	Input.action_release("down")

func _Moving_Slam():
	CheckSlam = true #For the EndSlam function. When you've reached the floor,
	#Game checks if you ahve CheckSlam or not, and if you do, emits the EndSlam Func
	acceleration = 0 #So you wouldn't go sidewayd
	velocity += Vector2(0, SlamPower)
	
func _End_Slam():
	$Slam.play("EndSlam")
	Input.action_release("down")
	var SLAMM = Slam.instance() #Area of slam
	SLAMM.position = position
	get_tree().current_scene.add_child(SLAMM)
	yield(get_tree().create_timer(.02), "timeout")
	SLAMM.queue_free() #Disappear after a delay

	var Rock = Rocks.instance()
	get_tree().current_scene.add_child(Rock)
	#Potato code. Just to add more 'Rocks'
	var Rock2 = Rocks.instance()
	get_tree().current_scene.add_child(Rock2)
#
func On_Ladder() -> bool:
	if Ladder and (Input.is_action_pressed("up") or (MyState != States.FLOOR and Input.is_action_pressed("down"))):
		Is_Slam = false
		return true
	else: return false

func _on_LadderChecker_body_entered(body):
	Ladder = true


func _on_LadderChecker_body_exited(body):
	Ladder = false
	
func Upgrade():
	HUD.Upgrade2()

func Fell():
	#Remembers the last position you've been on floor 
	position = posRemembered
	MyState = States.KNOCKED
	$Blink.play("Blink")

func Freeze():
	if MyState == States.FROZEN or UnFrozen == true:
		return
	FrostBar.FrostCount() #Frost debuff cooldown
	MyState = States.FROZEN

func Unfreeze():
	#Transition from Frozen state to Air state 
	if UnFrozen == false:
		return
	self.modulate = "ffffff"
	MyState = States.AIR
	yield(get_tree().create_timer(.8), "timeout") #A delay before you may be 
												  #Freezed again
	UnFrozen = false


func _on_Shield2_Frozen(var Seconds: int):
	#If you've parried a frostball, you get a debuff that you can't use parry
	#for a certain amount of time
	$NoShield.visible = true #Indicatoe
	Frozen = true
	yield(get_tree().create_timer(Seconds), "timeout")
	Frozen = false
	$NoShield.visible = false

func Door_Door():
	CloseToDoor = true


func Door_NoDoor():
	CloseToDoor = false
