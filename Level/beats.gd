extends Node2D

var time = 0
var last_beat_time = 0
var beat = (float(60) / float(GlobalBpm.bpm))
var on_beat = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	time += delta
	GlobalBpm.on_beat = bpm_tracker(time)

func bpm_tracker(time):
	var time_since_beat = fmod(time - last_beat_time, beat)

	if time >= last_beat_time + beat:
		last_beat_time += beat

	if time_since_beat < 0.3 :
		if not on_beat:
			$FreesoundCommunityMetronome85688.play()
			on_beat = true
			print("onnnnn")
	else:
		if on_beat:
			on_beat = false
			print("off")

	return on_beat
