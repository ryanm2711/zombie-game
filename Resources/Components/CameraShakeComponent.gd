class_name CameraShakeComponent extends Node3D

@export var camera: Camera3D

# This controls how fast the shake calms down (higher = stops faster)
@export var fade_speed: float = 15.0

var _shake_intensity: float = 0.0
var _shake_timer: float = -1
var _rng = RandomNumberGenerator.new()

@onready var initial_transform = camera.transform

func apply_shake(intensity: float, duration: float) -> void:
	_shake_intensity = intensity
	_shake_timer = duration
	
func _random_offset() -> Vector2:
	return Vector2(
		_rng.randf_range(-_shake_intensity, _shake_intensity),
		_rng.randf_range(-_shake_intensity, _shake_intensity)
	)
	
func _process(delta: float) -> void:
	if not camera:
		return
		
	if _shake_timer > 0.0:
		_shake_timer -= delta
		_shake_intensity = lerpf(_shake_intensity, 0, fade_speed * delta)
		
		var offset: Vector2 = _random_offset()
		camera.transform.origin = initial_transform.origin + Vector3(offset.x, offset.y, 0.0)
	else:
		if camera.transform.origin != initial_transform.origin:
			camera.transform.origin = camera.transform.origin.lerp(
				initial_transform.origin,
				fade_speed * delta
			)
