extends Node

@export var sounds: Array[SoundEffect] = []

var _sound_map: Dictionary = {}

func _ready() -> void:
	for sound in sounds:
		if sound and sound.name != &"":
			_sound_map[sound.name] = sound

func play(sound_id: StringName, volume_override: float = 0.0) -> void:
	if not _sound_map.has(sound_id):
		return
		
	var sfx: SoundEffect = _sound_map[sound_id]
	if not sfx.stream:
		return

	var player := AudioStreamPlayer.new()
	player.stream = sfx.stream
	player.volume_db = sfx.volume_db + volume_override
	
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
