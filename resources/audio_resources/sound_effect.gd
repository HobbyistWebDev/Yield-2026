extends Resource
class_name  SoundEffect

@export var name: StringName
@export var stream: AudioStream
@export_range(-80.0, 20.0) var volume_db: float = 0.0
