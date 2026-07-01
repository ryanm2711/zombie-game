extends Node3D

@export var lifetime: float = 120.0

func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
