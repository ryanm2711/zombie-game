extends Node3D

@export var lifetime: float = 0.001

func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
