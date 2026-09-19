extends TextureButton

@export var id:int = 0
signal press(id:int)

func _ready():
	connect("pressed", btn_down)

func btn_down():
	emit_signal("press", id)
