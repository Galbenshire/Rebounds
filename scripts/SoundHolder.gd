extends Node
class_name SoundHolder

func play(sound : String) -> void:
	var sound_node = get_node_or_null(sound)
	if sound_node:
		sound_node.play()
	else:
		printerr("ERROR: The sound %s doesn't exist in %s" % [sound, str(self)])
