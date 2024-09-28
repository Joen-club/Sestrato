extends Node
#Variables for speed, gravity:
export var D_Gravity = 1450.0
export var D_velocity = Vector2(0.0, 0.0)
export var D_currentSpeed = 0 #Временно равен нулю ради костыля для способности 
							#лазить по стенам, см. Jump и for loop сверху
export var D_acceleration = 20
							#to change velocity in the more easier way
#############################################################################
#############################################################################
#Jump Variables:

export var D_JumpPower = -500
export var D_SuperJump = -800
export var D_JumpScale = 2 #See the "LetsGO" Function. If it's = 3, you can do SuperJump
export var D_state = 0     #state(1,2) is a variable that 
export var D_state1 = 100  #is being used to maitain the height of the jump
export var D_state2 = 0
export var D_JumpWasPressed = false #Uses in multiple functions to use Coyote Timer
#############################################################################
#############################################################################
#SLAM:
export var D_SlamPower = 1000
#############################################################################
#############################################################################
#Dash variables (see "Dash" Function):
export var D_DashState = 0   #if this isn't equal to 0 you're not allowed to Dash
export var D_DashPower = Vector2(3500, -100)
#############################################################################
#############################################################################
#MONEY
export var D_Gold: int
export var level: int

export var OriginalInsideFromBalls = [Vector2(2466, -1753), Vector2(2533, -1798), 
Vector2(2188, -1800), Vector2(1860, -1784), Vector2(2185, -2019), Vector2(1831, -2005)]
