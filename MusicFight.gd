extends Node2D

var NearestTimeDiff = 9999
onready var Dragon = $BossDragon
onready var Magician = $BossMagician
onready var Audio = $AudioStreamPlayer

var MusicEvents = {
	2.1: "BreakPhase",
	2.2: "RageFlame",
	2.6: "BreakPhase",
	2.9: "RageFlame",
	3.1: "BreakPhase",
	3.3: "RageFlame",
	3.4: "BreakPhase",
	6.4: "RegularPhase",
	17.8: "IrregularPhase",
	29.5: "RegularPhaseMagician",
	40.7: "RegularPhaseMagician+",
	50.8: "RageFlame",
	51.1: "BreakPhase",
	51.3: "RageFlame",
	51.6: "BreakPhase",
	51.8: "RageFlame",
	52.1: "BreakPhase",
	57.7: "RegularPhasePlus",
	66.5: "SteadyPhase",
	69.3: "RegularPhasePlus",
	70.9: "IrregularPhasePlus",
	78: "SteadyPhase",
	81: "BreakPhaseBulletHell_1",
	83.3: "BreakPhaseBulletHell_2",
	86.6: "BreakPhaseBulletHell_1",
	89.7: "BreakPhaseBulletHell_3",
	92.8: "BreakPhase"
}

func _ready():
	pass

func _physics_process(delta):
	Music_Process()

func Music_Process():
	if Input.is_action_just_pressed("Tap"):
		print("Tapped")
	var k = $AudioStreamPlayer.get_playback_position() + AudioServer.get_time_since_last_mix()
	k -= AudioServer.get_output_latency()
	k = stepify(k, 0.1)
	if k == 98.5:
#		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.play(6.2)

	var NearestMusicEvent = null
	for time in MusicEvents.keys():
		var TimeDiff = abs(k - time)
		if TimeDiff < NearestTimeDiff:
			NearestTimeDiff = TimeDiff
			NearestMusicEvent = time
		if NearestTimeDiff <= 0.1:
			NearestTimeDiff = 9999
	
	if NearestMusicEvent != null:
		var action = MusicEvents[NearestMusicEvent]
#		NearestTimeDiff = 9999
		match action:
			"RageFlame":
				Dragon.ShootWaves()
				Dragon.Boss_State = 1
				Magician.Boss_State = 0
			"RegularPhase":
				Dragon.Boss_State = 0
				Magician.Boss_State = 1
			"IrregularPhase":
				Dragon.Boss_State = 2
				Magician.Boss_State = 1
			"SteadyPhase":
				Magician.Boss_State = 7
				Dragon.Boss_State = 4
			"RegularPhasePlus":
				Dragon.Boss_State = 0
				Magician.Boss_State = 7
			"IrregularPhasePlus":
				Dragon.Boss_State = 2
				Magician.Boss_State = 7
			"BreakPhase":
				Dragon.Boss_State = 3
				Magician.Boss_State = 0
			"RegularPhaseMagician":
				Dragon.Boss_State = 0
				Magician.Boss_State = 2
				
			"RegularPhaseMagician+":
				Dragon.Boss_State = 0
				Magician.Boss_State = 3
			"BreakPhaseBulletHell_1":
				Dragon.Boss_State = 3
				Magician.Boss_State = 4
			"BreakPhaseBulletHell_2":
				Magician.Boss_State = 5
			"BreakPhaseBulletHell_3":
				Magician.Boss_State = 6

func _on_Portal_body_entered(body):
	$AudioStreamPlayer.play()
	pass # Replace with function body.

func _on_BossBar_Boss_Is_Dead():
	$AudioStreamPlayer.stop()
	Dragon.Boss_State = 3
	Magician.Boss_State = 0
	Dragon.Died()
	Magician.Defeated()
