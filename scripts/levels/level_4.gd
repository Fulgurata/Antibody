extends Node2D








func _on_music_trigger_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var bpm = 120.0
		var beats_per_measure = 4.0
		var measure_length = (60.0 / bpm) * beats_per_measure  # = 2 seconds at 120 BPM in 4/4
		var main_track = $music_1
		var layer_track = $music_2
		var current_pos = main_track.get_playback_position()
		var time_until_next_measure = measure_length - fposmod(current_pos, measure_length)
		await get_tree().create_timer(time_until_next_measure).timeout
		layer_track.play()
